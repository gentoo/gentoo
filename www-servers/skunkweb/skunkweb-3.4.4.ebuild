# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit apache-module eutils multilib python user

DESCRIPTION="robust Python web application server"
HOMEPAGE="http://skunkweb.sourceforge.net/"
SRC_URI="mirror://sourceforge/skunkweb/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-admin/sudo
	>=dev-python/egenix-mx-base-2.0.4"
RDEPEND="${DEPEND}"

need_apache

APACHE2_MOD_FILE="${S}/SkunkWeb/mod_skunkweb/.libs/mod_skunkweb.so"
APACHE2_MOD_DEFINE="SKUNKWEB"
APACHE2_MOD_CONF="100_mod_skunkweb"

pkg_setup() {
	enewgroup skunkweb
	enewuser skunkweb -1 -1 /usr/share/skunkweb skunkweb

	python_set_active_version 2
}

src_configure() {
	econf \
		--with-user=skunkweb \
		--with-group=skunkweb \
		--localstatedir=/var/lib/skunkweb \
		--bindir=/usr/bin \
		--libdir=/usr/$(get_libdir)/skunkweb \
		--sysconfdir=/etc/skunkweb \
		--prefix=/usr/share/skunkweb \
		--with-cache=/var/lib/skunkweb/cache \
		--with-docdir=/usr/share/doc/${P} \
		--with-logdir=/var/log/skunkweb \
		--with-python="$(PYTHON -a)" \
		--with-apxs=${APXS}
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" APXSFLAGS="-c" install || die "emake install failed"
	apache-module_src_install

	python_need_rebuild

	keepdir /var/{lib,log}/${PN}
	keepdir /var/lib/${PN}/run
	fowners skunkweb:skunkweb /var/{lib,log}/${PN}

	newinitd "${FILESDIR}"/skunkweb-init skunkweb
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/skunkweb-cron-cache_cleaner skunkweb-cache_cleaner

	dodoc README ChangeLog NEWS HACKING ACKS INSTALL
}

pkg_postinst() {
	apache-module_pkg_postinst
	python_mod_optimize /usr/$(get_libdir)/skunkweb
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/skunkweb
}
