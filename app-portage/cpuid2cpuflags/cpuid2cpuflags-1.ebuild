# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

MY_PN=cpuinfo2cpuflags
MY_P=${MY_PN}-${PV}
DESCRIPTION="Script to guess CPU_FLAGS_X86 flags from /proc/cpuinfo"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags"
SRC_URI="https://github.com/mgorny/cpuid2cpuflags/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=${PYTHON_DEPS}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${MY_P}

src_install() {
	python_foreach_impl python_newscript "${MY_PN}-x86"{.py,}
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
