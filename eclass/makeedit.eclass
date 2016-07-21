# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: makeedit.eclass
# @AUTHOR:
# Spider
# @BLURB: An eclass to replace some flags in makefiles
# @DESCRIPTION:
#
# @CODE
# To use this eclass, do 2 things:
#   1. append-flags "$MAKEEDIT_FLAGS".  If you filter-flags, make sure to do
#      the append-flags afterward, otherwise you'll lose them.
#   2. after running configure or econf, call edit_makefiles to remove
#      extraneous CFLAGS from your Makefiles.
# @CODE
#
# This combination should reduce the RAM requirements of your build, and maybe
# even speed it up a bit.


MAKEEDIT_FLAGS="-Wno-return-type -w"

# @FUNCTION: edit_makefiles
# @DESCRIPTION:
# Removes some flags in makefiles
edit_makefiles() {
	# We already add "-Wno-return-type -w" to compiler flags, so
	# no need to replace "-Wall" and "-Wreturn-type" with them.
	einfo "Parsing Makefiles ..."
	find . \( -iname makefile -o -name \*.mk -o -name GNUmakefile \) -print0 | \
		xargs -0 sed -i \
		-e 's:-Wall::g' \
		-e 's:-Wreturn-type::g' \
		-e 's:-pedantic::g'
}
