# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs multilib-minimal

DESCRIPTION="stateless, zlib-compatible, and very fast compression library"
HOMEPAGE="http://1wt.eu/projects/libslz"
SRC_URI="http://git.1wt.eu/web?p=${PN}.git;a=snapshot;h=v${PV};sf=tbz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 arm ppc ~x86"
IUSE="static-libs tools"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_compile() {
	local -a opts=(
		CC="$(tc-getCC)" \
		OPT_CFLAGS="${CFLAGS}" \
		USR_LFLAGS="${LDFLAGS}" \
		shared \
		$(usex static-libs static '')
	)

	if multilib_is_native_abi ; then
		opts+=(
			$(usex tools tools '')
		)
	fi

	emake "${opts[@]}"
}

multilib_src_install() {
	local -a opts=(
		STRIP=":" \
		DESTDIR="${ED}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install-headers
		install-shared \
		$(usex static-libs install-static '')
	)

	if multilib_is_native_abi ; then
		einstalldocs

		opts+=(
			$(usex tools install-tools '')
		)
	fi

	emake "${opts[@]}"
}
