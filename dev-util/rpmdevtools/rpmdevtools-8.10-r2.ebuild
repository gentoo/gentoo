# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit python-single-r1

DESCRIPTION="Collection of rpm packaging related utilities"
HOMEPAGE="https://pagure.io/rpmdevtools"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	app-arch/rpm[python,${PYTHON_SINGLE_USEDEP}]
	dev-lang/perl:*
"
RDEPEND="${COMMON_DEPEND}
	net-misc/curl
	emacs? ( app-emacs/rpm-spec-mode )
"
DEPEND="${COMMON_DEPEND}
	sys-apps/help2man
"

src_prepare() {
	default
	python_fix_shebang rpmdev-{rmdevelrpms.py,checksig,sort,vercmp,bumpspec}
}
