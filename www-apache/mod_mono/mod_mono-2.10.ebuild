# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Watch the order of these!
inherit autotools apache-module multilib eutils go-mono mono

KEYWORDS="amd64 ppc x86"

DESCRIPTION="Apache module for Mono"
HOMEPAGE="http://www.mono-project.com/Mod_mono"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug"

DEPEND="=dev-dotnet/xsp-${GO_MONO_REL_PV}*"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="2.2/70_${PN}"
APACHE2_MOD_DEFINE="MONO"

DOCFILES="AUTHORS ChangeLog COPYING INSTALL NEWS README"

need_apache2

src_prepare() {
	sed -e "s:@LIBDIR@:$(get_libdir):" "${FILESDIR}/${APACHE2_MOD_CONF}.conf" \
		> "${WORKDIR}/${APACHE2_MOD_CONF##*/}.conf" || die

	epatch "${FILESDIR}"/${PN}-2.10-apache-2.4.patch

	eautoreconf
	go-mono_src_prepare
}

src_configure() {
	export LIBS="$(pkg-config --libs apr-1)"
	go-mono_src_configure \
		$(use_enable debug) \
		--with-apxs="${APXS}" \
		--with-apr-config="/usr/bin/apr-1-config" \
		--with-apu-config="/usr/bin/apu-1-config"
}
src_compile() {
	go-mono_src_compile
}

src_install() {
	go-mono_src_install
	find "${D}" -name 'mod_mono.conf' -delete || die "failed to remove mod_mono.conf"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${WORKDIR}/${APACHE2_MOD_CONF##*/}.conf" "${APACHE2_MOD_CONF##*/}.conf" \
		|| die "internal ebuild error: '${FILESDIR}/${APACHE2_MOD_CONF}.conf' not found"
}

pkg_postinst() {
	apache-module_pkg_postinst

	elog "To enable mod_mono, add \"-D MONO\" to your Apache's"
	elog "conf.d configuration file. Additionally, to view sample"
	elog "ASP.NET applications, add \"-D MONO_DEMO\" too."
}
