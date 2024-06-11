# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1

DESCRIPTION="Collection of rpm packaging related utilities"
HOMEPAGE="https://pagure.io/rpmdevtools"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	app-arch/rpm[python,${PYTHON_SINGLE_USEDEP}]
	dev-lang/perl:*
	$(python_gen_cond_dep '
		dev-python/progressbar2[${PYTHON_USEDEP}]
		dev-python/requests_download[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	net-misc/curl
	emacs? ( app-emacs/rpm-spec-mode )
"
BDEPEND="sys-apps/help2man"

src_prepare() {
	default
	python_fix_shebang rpmdev-{bumpspec,checksig,rmdevelrpms.py,sort,spectool,vercmp}
}
