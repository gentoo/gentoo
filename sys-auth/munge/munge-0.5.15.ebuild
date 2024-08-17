# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools prefix systemd tmpfiles

DESCRIPTION="An authentication service for creating and validating credentials"
HOMEPAGE="https://github.com/dun/munge"
SRC_URI="https://github.com/dun/munge/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="debug gcrypt static-libs"
# TODO: still tries to use ${S}?
RESTRICT="test"

DEPEND="
	app-arch/bzip2
	sys-libs/zlib
	gcrypt? ( dev-libs/libgcrypt:= )
	!gcrypt? ( dev-libs/openssl:= )
"
RDEPEND="
	${DEPEND}
	acct-group/munge
	acct-user/munge
"
BDEPEND="app-arch/xz-utils[extra-filters(+)]"

src_prepare() {
	default

	hprefixify config/x_ac_path_openssl.m4

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-logrotateddir="${EPREFIX}"/etc/logrotate.d
		--with-pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		--with-crypto-lib=$(usex gcrypt libgcrypt openssl)
		$(use_enable debug)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Note that both verboses seem to be needed, otherwise output
	# is verbose but not maximally so
	emake check root="${T}"/munge VERBOSE=t verbose=t
}

src_install() {
	default

	# bug #450830
	if [[ -d "${ED}"/var/run ]] ; then
		rm -rf "${ED}"/var/run || die
	fi

	dodir /etc/munge
	keepdir /var/{lib,log}/munge

	local d
	for d in "init.d" "default" "sysconfig"; do
		if [[ -d "${ED}"/etc/${d} ]] ; then
			rm -r "${ED}"/etc/${d} || die
		fi
	done

	newconfd "$(prefixify_ro "${FILESDIR}"/${PN}d.confd)" ${PN}d
	newinitd "$(prefixify_ro "${FILESDIR}"/${PN}d.initd)" ${PN}d

	newtmpfiles "${FILESDIR}"/munged.tmpfiles.conf munged.conf

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	tmpfiles_process munged.conf
}
