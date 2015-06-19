# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/atheme-services/atheme-services-9999.ebuild,v 1.7 2014/11/10 22:49:18 dilfridge Exp $

EAPI=5

inherit git-2 user eutils flag-o-matic perl-module

MY_P=${P/_/-}

DESCRIPTION="A portable and secure set of open-source and modular IRC services"
HOMEPAGE="http://atheme.net/"
EGIT_REPO_URI="git://github.com/atheme/atheme.git"
EGIT_HAS_SUBMODULES="true"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="cracklib largenet ldap nls +pcre perl profile ssl"

RDEPEND="=dev-libs/libmowgli-9999:2
	cracklib? ( sys-libs/cracklib )
	ldap? ( net-nds/openldap )
	nls? ( sys-devel/gettext )
	perl? ( dev-lang/perl )
	pcre? ( dev-libs/libpcre )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	# the dependency calculation puts all of the .c files together and
	# overwhelms cc1 with this flag :-(
	filter-flags -combine

	if use profile; then
		# bug #371119
		ewarn "USE=\"profile\" is incompatible with the hardened profile's -pie flag."
		ewarn "Disabling PIE. Please ignore any warning messages about -nopie being invalid."
		append-flags -nopie
	fi

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/atheme ${PN}
}

# To stop perl-module overriding this function
src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	# fix docdir
	sed -i -e 's/\(^DOCDIR.*=.\)@DOCDIR@/\1@docdir@/' extra.mk.in || die

	# basic logging config directive fix
	sed -i -e '/^logfile/s;var/\(.*\.log\);'"${EPREFIX}"'/var/log/atheme/\1;g' dist/* || die

	# QA against bundled libs.
	# But comment it out in the live ebuild
	# because it only contains a git submodule
	# and removing it MAY break everything.
	#rm -rf libmowgli-2 || die
}

src_configure() {
	econf \
		atheme_cv_c_gcc_w_error_implicit_function_declaration=no \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--localstatedir="${EPREFIX}"/var \
		--enable-fhs-paths \
		--disable-warnings \
		--enable-contrib \
		$(use_enable largenet large-net) \
		$(use_with cracklib) \
		$(use_with ldap) \
		$(use_with nls) \
		$(use_enable profile) \
		$(use_with perl) \
		$(use_with pcre) \
		$(use_enable ssl)
}

src_compile() {
	emake V=1
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/${PN}
	for conf in dist/*.example; do
		# The .cron file isn't meant to live in /etc/${PN}, so only
		# install a .example version.
		[[ ${conf} == *cron* ]] && continue

		newins ${conf} $(basename ${conf} .example)
	done

	fowners -R 0:${PN} /etc/${PN}
	keepdir /var/{lib,log}/atheme
	fowners ${PN}:${PN} /var/{lib,log,run}/atheme
	fperms -R go-w,o-rx /etc/${PN}
	fperms 750 /etc/${PN} /var/{lib,log,run}/atheme

	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	mv "${ED}"/usr/bin/{,atheme-}dbverify || die

	# contributed scripts and such:
	insinto /usr/share/doc/${PF}/contrib
	doins contrib/*.{c,pl,php,py,rb}

	if use perl; then
		perl_set_version
		insinto "${VENDOR_LIB#${EPREFIX}}"
		doins -r contrib/Atheme{,.pm}
	fi
}
