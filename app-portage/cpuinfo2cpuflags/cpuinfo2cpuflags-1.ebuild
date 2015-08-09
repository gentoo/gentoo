# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit python-r1

DESCRIPTION="Script to guess CPU_FLAGS_X86 flags from /proc/cpuinfo"
HOMEPAGE="https://bitbucket.org/mgorny/cpuinfo2cpuflags"
SRC_URI="https://bitbucket.org/mgorny/cpuinfo2cpuflags/downloads/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=${PYTHON_DEPS}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_install() {
	python_foreach_impl python_newscript "${PN}-x86"{.py,}
}

pkg_postinst() {
	if has_version 'sys-apps/portage' \
		&& ! has_version "sys-apps/portage[${PYTHON_USEDEP}]"
	then
		ewarn "Support for matching Python implementations should be enabled"
		ewarn "on sys-apps/portage as well. Otherwise, cpuinfo2cpuflags won't"
		ewarn "be able to figure out the correct repository location and will"
		ewarn "require you to specify it explicitly."
	fi
}
