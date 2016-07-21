# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ETYPE=sources
K_DEFCONFIG="bcmrpi_defconfig"
K_SECURITY_UNSUPPORTED=1
UNIPATCH_LIST="${DISTDIR}/${PF}.patch.xz"
CKV="3.10.1"
inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Raspberry PI kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
# from github.com/rasperrypi/firmware/extra/git_hash
# MY_COMMIT="b04d3b1874"
# https://github.com/raspberrypi/linux/tarball/${MY_COMMIT} ->
#		raspberrypi-sources-${MY_COMMIT}.tar.gz
SRC_URI="${KERNEL_URI}
	https://dev.gentoo.org/~xmw/${PN}/${PF}.patch.xz"

KEYWORDS="~arm"
