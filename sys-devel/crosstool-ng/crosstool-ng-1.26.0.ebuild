# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1

DESCRIPTION="Versatile (cross-)toolchain generator"
HOMEPAGE="https://crosstool-ng.github.io/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/crosstool-ng/crosstool-ng.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/crosstool-ng/crosstool-ng/releases/download/${PN}-${PV/_rc/-rc}/${P}.tar.xz
		http://crosstool-ng.org/download/crosstool-ng/${P}.tar.xz
	"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~x86"
	fi
fi

LICENSE="GPL-2 doc? ( CC-BY-SA-2.5 )"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="curl cvs doc dtc git lzip meson ninja python rsync subversion wget"

# TODO: Consider dropping these USE (optfeature), but configure does check for them
BDEPEND="
	app-arch/unzip
	>=app-shells/bash-3.1
	sys-apps/help2man
	>=sys-apps/sed-4.0
	sys-apps/gawk
	sys-apps/texinfo
	sys-devel/bison
	sys-devel/flex
	curl? ( net-misc/curl )
	cvs? ( dev-vcs/cvs )
	dtc? ( sys-apps/dtc )
	git? ( dev-vcs/git )
	lzip? ( app-arch/lzip )
	meson? ( dev-build/meson )
	python? ( ${PYTHON_DEPS} )
	ninja? ( app-alternatives/ninja )
	rsync? ( net-misc/rsync )
	subversion? ( dev-vcs/subversion )
	wget? ( net-misc/wget )
"
RDEPEND="
	${BDEPEND}
"

src_configure() {
	# Needs bison+flex
	unset YACC LEX

	default
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc ; then
		mv "${ED}"/usr/share/doc/crosstool-ng/crosstool-ng-${PVR} "${ED}"/usr/share/doc/ || die
	fi

	rm -rf "${ED}"/usr/share/doc/crosstool-ng || die
	rm -rf "${ED}"/usr/share/man/man1/ct-ng.1.gz || die
	doman docs/ct-ng.1
}
