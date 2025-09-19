# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL=no
inherit autotools flag-o-matic perl-module

DESCRIPTION="Hub software for Direct Connect, fork of opendchub"
HOMEPAGE="https://sourceforge.net/projects/dbhub/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug nls perl switch-user ${GENTOO_PERL_USESTRING}"

DEPEND="
	virtual/libcrypt:=
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
	switch-user? ( sys-libs/libcap )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-no-dynaloader.patch
	"${FILESDIR}"/${PN}-fix-buffer-overflows.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fcommon

	# bashism in perl check
	CONFIG_SHELL="${BROOT}"/bin/bash econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable switch-user switch_user)
}

src_compile() {
	# Avoid perl-module_src_compile (bug #963096)
	default
}

src_test() {
	# Avoid perl-module_src_test (bug #963096)
	default
}

src_install() {
	# Avoid perl-module_src_install (bug #963096)
	default
}
