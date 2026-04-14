INSTALL_DIR ?= ~/.local/bin

.PHONY: build install uninstall clean

build:
	swift build -c release

install: build
	@mkdir -p $(INSTALL_DIR)
	install .build/release/dt $(INSTALL_DIR)/dt
	ln -sf $(INSTALL_DIR)/dt $(INSTALL_DIR)/dt-cli
	@echo "Installed dt and dt-cli → $(INSTALL_DIR)"

uninstall:
	rm -f $(INSTALL_DIR)/dt $(INSTALL_DIR)/dt-cli $(INSTALL_DIR)/devonthink
	@echo "Removed dt, dt-cli, and devonthink (if present) from $(INSTALL_DIR)"

clean:
	swift package clean
