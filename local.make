TEX_VARS = -V documentclass=scrreprt --include-in-header=$(MAKESPEC)/gbvstyle.tex -V toc-depth=3
ifneq ($(VERSION),)
	DATE += "\(version $(VERSION)\)"
endif
