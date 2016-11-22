# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1.gcbf2a35"

inherit eutils openib

DESCRIPTION="A library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!sys-fabric/openib-userspace"
block_other_ofed_versions
