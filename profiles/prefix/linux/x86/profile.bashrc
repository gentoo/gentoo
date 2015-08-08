# Copyright 1999-2011 Gentoo Foundation; Distributed under the GPL v2
# $Id$

# When x86-linux runs on an amd64 host having /lib32,
# we need to have binutils to search there too (#360197).
# The patches to do so are applied upon SYMLINK_LIB=yes,
# needed when /lib32 is (a symlink to) an existing directory.
if [[ ${CATEGORY}/${PN} = sys-devel/binutils ]] \
&& [[ ${EBUILD_PHASE} == setup ]] \
&& [[ -d ${ROOT}lib32/. ]] \
; then
	export SYMLINK_LIB=yes
fi
