########################################################################
# Create VERSION variable from git repository, unless already set      #
########################################################################

# make sure there is a git repository
HAS_REPOSITORY = $(shell $(GIT) rev-parse --git-dir 2>/dev/null)
GIT_WITH_REPO  = $(if $(HAS_REPOSITORY),$(GIT),$(error "Not a git repository - call 'git init'!"))

ifndef VERSION
 
	# get latest version tag (possibly empty) or exit if no git repository
	VERSION_TAG := $(shell $(GIT_WITH_REPO) describe --abbrev=0 --tags 2>/dev/null | grep '^v\?[0-9]' | head -1)
	VERSION := $(shell echo $(VERSION_TAG) | sed 's/^v//')

	ifneq ($(REVHASH),)
		VERSION_HASH = $(if $(VERSION),$(shell $(GIT) rev-list ${VERSION_TAG} | head -1))
		FILES_CHANGED = $(shell $(GIT) status --porcelain 2>/dev/null | sed '/^??/d' )

		ifneq ($(VERSION_HASH),$(REVHASH))
			ifeq ($(VERSION_HASH),)
				COMMITS_SINCE_VERSION=$(shell $(GIT) rev-list --all | wc -l)
			else
				COMMITS_SINCE_VERSION=$(shell $(GIT) rev-list $(VERSION_TAG).. | wc -l)
			endif
			ifneq ($(FILES_CHANGED),)
				VERSION := $(VERSION)+$(COMMITS_SINCE_VERSION)-dirty
			else
				VERSION := $(VERSION)+$(COMMITS_SINCE_VERSION)
			endif
		else
			ifneq ($(FILES_CHANGED),)
				VERSION := $(VERSION)+dirty
			endif
		endif

	else # not commited yet
		VERSION := 0.0.0
	endif

else
	ifeq ($(VERSION),none)
		VERSION := 
	endif
endif

ifneq ($(VERSION),)
	ABOUT_VERSION=" - version $(VERSION)"
endif

