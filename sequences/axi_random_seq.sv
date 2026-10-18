class axi_random_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_random_seq)

    rand int unsigned num_txns       = 100;
    rand int unsigned addr_region    = 0;   // 0=low, 1=mid, 2=high, 3=wide

    function new(string name="axi_random_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item it;
        for (int i = 0; i < num_txns; i++) begin
            it = axi_seq_item::type_id::create($sformatf("rnd_%0d", i));
            start_item(it);

            if (!it.randomize() with {
                // Aligned address
                addr[1:0] == 2'b00;

                // Region selection
                if (addr_region == 0) addr inside {[32'h0000_0000:32'h0000_0FFF]};
                if (addr_region == 1) addr inside {[32'h0000_1000:32'h0000_FFFF]};
                if (addr_region == 2) addr inside {[32'h0001_0000:32'hFFFF_FFFC]};

                // 50/50 read vs write
                kind dist {axi_seq_item::AXI_WRITE := 50,
                           axi_seq_item::AXI_READ  := 50};

                // Backpressure ranges (0,1,2,5+ cycles)
                bready_delay inside {[0:8]};
                rready_delay inside {[0:8]};

                // Byte strobe — kept legal, but RTL ignores it
                strb inside {4'hF, 4'h0, 4'h3, 4'hC};

                // Single beat only (RTL doesn't do bursts)
                len  == 0;
                size == 3'b010;      // 4 bytes
                burst == 2'b01;      // INCR
                last == 1;
            }) begin
                `uvm_error("RAND_SEQ", $sformatf("Randomize failed on txn %0d", i))
                return;
            end

            finish_item(it);
        end
    endtask
endclass