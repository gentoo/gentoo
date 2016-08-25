# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utilities to detect broken or counterfeit flash storage"
HOMEPAGE="http://oss.digirati.com.br/f3/ https://github.com/AltraMayor/f3"

PATCHES=(
	"${FILESDIR}"/f3-6.0-fix-compiler-warnings_f3read.patch
	"${FILESDIR}"/f3-6.0-fix-compiler-warnings_f3probe.patch
	"${FILESDIR}"/f3-6.0-respect-ldflags.patch
	"${FILESDIR}"/f3-6.0-use-argp_parse.patch
	"${FILESDIR}"/f3-6.0-extra-target.patch
	"${FILESDIR}"/f3-6.0-upstream-issue-44.patch
)

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="
		git://github.com/AltraMayor/${PN}.git
		https://github.com/AltraMayor/${PN}.git
		"

	PATCHES=()

	inherit git-r3
else
	SRC_URI="https://github.com/AltraMayor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="extra"

DEPEND="extra? (
		sys-block/parted
		virtual/udev
	)"

RDEPEND=""

DOCS=( changelog README.md )

src_prepare() {
	default

	sed -i \
		-e 's:-ggdb::' \
		-e 's:^PREFIX =:PREFIX ?=:' \
		Makefile || die

	tc-export CC

	append-cflags -fgnu89-inline # https://github.com/AltraMayor/f3/issues/34
}

src_compile() {
	default

	if use extra; then
		emake V=1 extra
	fi
}

src_install() {
	emake PREFIX="${ED%/}/usr" install

	if use extra; then
		emake PREFIX="${ED%/}/usr" install-extra
	fi

	dodoc "${DOCS[@]}"
}
