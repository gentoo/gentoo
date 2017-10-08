# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# QA failiures reported in https://code.monotone.ca/p/monotone/issues/181/
EAPI=6
inherit bash-completion-r1 elisp-common tmpfiles user

DESCRIPTION="Monotone Distributed Version Control System"
HOMEPAGE="http://monotone.ca"
SRC_URI="http://monotone.ca/downloads/${PV}/${P}.tar.bz2
	http://dev.gentoo.org/~axs/distfiles/${P}-patches.tar.xz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ia64 x86"
IUSE="doc ipv6 nls test"

RDEPEND="sys-libs/zlib:0=
	>=dev-libs/libpcre-7.6
	>=dev-libs/botan-1.8.0:0
	>=dev-db/sqlite-3.3.8
	>=dev-lang/lua-5.1:=
	net-dns/libidn"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	nls? ( >=sys-devel/gettext-0.11.5 )
	doc? ( sys-apps/texinfo )
	test? ( dev-tcltk/expect
		app-shells/bash-completion )"

pkg_setup() {
	enewgroup monotone
	enewuser monotone -1 -1 /var/lib/monotone monotone
}

src_prepare() {
	if [[ $(gcc-major-version) -lt "3"  ||
		( $(gcc-major-version) -eq "3" && $(gcc-minor-version) -le 3 ) ]]; then
		die 'requires >=gcc-3.4'
	fi
	eapply -p0 "${WORKDIR}/monotone-patches/monotone-1.0-bash-completion-tests.patch"
	eapply -p0 "${WORKDIR}/monotone-patches/monotone-1.0-botan-1.10-v2.patch"
	eapply -p0 "${WORKDIR}/monotone-patches/monotone-1.0-glibc-2.14-file-handle.patch"
	eapply -p0 "${WORKDIR}/monotone-patches/monotone-1.0-boost-1.53.patch"
	eapply "${WORKDIR}/monotone-patches/monotone-1.0-pcre3.patch"
	eapply -p0 "${WORKDIR}/monotone-patches/monotone-1.0-texinfo-5.1.patch"
	eapply "${WORKDIR}/monotone-patches/monotone-1.0-gcc6.patch"
	eapply_user
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable ipv6)
}

src_compile() {
	emake
	use doc && emake html
}

src_test() {
	# Disables netsync_bind_opt test
	# https://code.monotone.ca/p/monotone/issues/179/
	export DISABLE_NETWORK_TESTS=true
	if [[ ${UID} != 0 ]]; then
		emake check
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	rm "${ED}"/etc/bash_completion.d/monotone.bash_completion || die
	newbashcomp extra/shell/monotone.bash_completion ${PN}

	if use doc; then
		dodoc -r doc/html/*
		dodoc -r doc/figures
	fi

	dodoc AUTHORS NEWS README* UPGRADE
	docinto contrib
	docompress -x /usr/share/doc/${PF}/contrib
	dodoc -r contrib
	newconfd "${FILESDIR}"/monotone.confd monotone
	newinitd "${FILESDIR}"/${PN}-0.36.initd monotone

	insinto /etc/monotone
	newins "${FILESDIR}"/hooks.lua hooks.lua
	newins "${FILESDIR}"/read-permissions read-permissions
	newins "${FILESDIR}"/write-permissions write-permissions

	dodir /var/run/monotone
	keepdir /var/lib/monotone/keys /var/log/monotone
	fowners monotone:monotone /var/lib/monotone{,/keys} /var/{log,run}/monotone

	cat <<EOF >"${T}"/monotone.conf
d /run/monotone 0755 monotone monotone
EOF
	dotmpfiles "${T}"/monotone.conf
}

pkg_postinst() {
	elog
	elog "For details and instructions to upgrade from previous versions,"
	elog "please read /usr/share/doc/${PF}/UPGRADE.bz2"
	elog
	elog "  1. edit /etc/conf.d/monotone"
	elog "  2. import the first keys to enable access with"
	elog "     env HOME=\${homedir} mtn pubkey me@example.net | /etc/init.d/monotone import"
	elog "     Thereafter, those with write permission can add other keys via"
	elog "     netsync with 'monotone push --key-to-push=IDENT' and then IDENT"
	elog "     can be used in the read-permission and write-permission files."
	elog "  3. adjust permisions in /etc/monotone/read-permissions"
	elog "                      and /etc/monotone/write-permissions"
	elog "  4. start the daemon: /etc/init.d/monotone start"
	elog "  5. make persistent: rc-update add monotone default"
	elog
}
