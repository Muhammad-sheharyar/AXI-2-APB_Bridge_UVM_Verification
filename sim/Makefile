# ==========================================
# AXI2APB UVM Makefile
# ==========================================
TEST        ?= reset_test
SEED        ?= 1
VERBOSITY   ?= UVM_LOW

# Create output, log, and result directories automatically if they don't exist
$(shell mkdir -p ./out ../logs ../results)

# List of all tests for regression
ALL_TESTS = reset_test \
            axi_write_ready_test \
            axi_read_ready_test \
            axi_write_wait_test \
            axi_read_wait_test \
            bready_delay_test \
            rready_delay_test \
            rd_wr_priority_test \
            bk2bk_read_test \
            bk2bk_write_test \
            mixed_traffic_test \
            id_user_test \
            pslverr_test \
            rand_test \
            rand_axi_test \
            rand_mixed_test \
			coverage_closure_test 

# ------------------------------------------
# COMPILE
# ------------------------------------------
compile:
	@echo "==================================================="
	@echo " Compiling Test: $(TEST)"
	@echo "==================================================="
	vcs -sverilog -f build.flist -ntb_opts uvm-1.2 -timescale=1ns/1ps \
	    +UVM_TESTNAME=$(TEST) \
	    -cm line+cond+fsm+tgl+branch+assert \
		-LDFLAGS -Wl,--no-as-needed -full64 -debug_access+all
	@echo "---------------------------------------------------"
	@echo " Moving build artifacts to out/build_$(TEST)/"
	@echo "---------------------------------------------------"
	cd ./out && rm -rf build_$(TEST) && mkdir -p build_$(TEST)
	mv csrc simv.daidir simv.vdb simv vc_hdrs.h ./out/build_$(TEST) 2>/dev/null || true
	@echo "=== Compile DONE - out/build_$(TEST) ==="

# ------------------------------------------
# SIMULATE
# ------------------------------------------
sim: compile
	@echo "==================================================="
	@echo " Simulating Test: $(TEST) | Seed: $(SEED)"
	@echo "==================================================="
	@cd ./out/build_$(TEST) && ./simv -cm line+cond+fsm+tgl+branch+assert \
	    -cm_name $(TEST) \
		+UVM_TESTNAME=$(TEST) \
	    +UVM_VERBOSITY=$(VERBOSITY) \
	    +ntb_random_seed=$(SEED) \
	    > ../../../logs/$(TEST)_seed$(SEED).log
	@echo "=== Sim DONE - logs/$(TEST)_seed$(SEED).log ==="
	@echo "==================================================="
	@echo " Auto-Parsing Log for Errors..."
	@echo "==================================================="
	@python3 ../scripts/parse_log.py ../logs/$(TEST)_seed$(SEED).log

# ------------------------------------------
# GUI (Waveform)
# ------------------------------------------
gui: compile
	@echo "=== Opening GUI for $(TEST) ==="
	cd ./out/build_$(TEST) && ./simv -gui +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) &

parse_log:
	@echo "==================================================="
	@echo " Parsing Log for Test: $(TEST)"
	@echo "==================================================="
	python3 ../scripts/parse_log.py ../logs/$(TEST).log

# ------------------------------------------
# REGRESSION (All Tests)
# ------------------------------------------
regression:
	@echo "==================================================="
	@echo " Compiling once for Regression"
	@echo "==================================================="
	vcs -sverilog -f build.flist -ntb_opts uvm-1.2 -timescale=1ns/1ps \
	    +UVM_TESTNAME=reset_test \
	    -cm line+cond+fsm+tgl+branch+assert \
		-LDFLAGS -Wl,--no-as-needed -full64 -debug_access+all
	@echo "---------------------------------------------------"
	@echo " Moving build artifacts to out/build_regression/"
	@echo "---------------------------------------------------"
	cd ./out && rm -rf build_regression && mkdir -p build_regression
	mv csrc simv.daidir simv.vdb simv vc_hdrs.h ./out/build_regression/ 2>/dev/null || true
	@echo "==================================================="
	@echo " Running All 17 Tests"
	@echo "==================================================="
	@rm -f ../results/regression_summary.txt
	@for t in $(ALL_TESTS); do \
		echo "Running Test: $$t ..."; \
		(cd ./out/build_regression && ./simv -cm line+cond+fsm+tgl+branch+assert -cm_name $$t +UVM_TESTNAME=$$t +ntb_random_seed=$(SEED) > ../../../logs/$$t.log 2>&1); \
		if grep -q "UVM_ERROR :    0" ../logs/$$t.log && grep -q "UVM_FATAL :    0" ../logs/$$t.log; then \
			echo "$$t: PASS" >> ../results/regression_summary.txt; \
		else \
			echo "$$t: FAIL" >> ../results/regression_summary.txt; \
		fi; \
	done
	@echo "==================================================="
	@echo " Regression Summary (results/regression_summary.txt)"
	@echo "==================================================="
	@cat ../results/regression_summary.txt
	@echo "==================================================="

# ------------------------------------------
# COVERAGE REPORT
# ------------------------------------------
cov:
	@echo "==================================================="
	@echo " Generating Combined Coverage Report (All 17 Tests)"
	@echo "==================================================="
	urg -full64 -dir ./out/build_regression/simv.vdb -report ./out/coverage_report
	@echo "=== Coverage report generated in out/coverage_report ==="

# ------------------------------------------
# CLEANING TARGETS
# ------------------------------------------
clean:
	@echo "Cleaning build and logs for $(TEST)..."
	rm -rf ./out/build_$(TEST)
	rm -f ../logs/$(TEST)_seed*.log
	rm -f ../logs/$(TEST).log
	@echo "=== Clean DONE for $(TEST) ==="

allclean:
	@echo "==================================================="
	@echo " Removing ALL builds and logs"
	@echo "==================================================="
	rm -rf ./out/*
	rm -f ../logs/*.log
	rm -f ../results/*.txt
	rm -f ../sim/DVEfiles/*
	@echo "=== All Clean DONE ==="

.PHONY: compile sim gui regression cov clean allclean