# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/audit-1.7.18.ebuild,v 1.1 2012/12/18 21:57:17 robbat2 Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit autotools eutils multilib toolchain-funcs python eutils

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="http://people.redhat.com/sgrubb/audit/"
SRC_URI="http://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ldap"
# Testcases are pretty useless as they are built for RedHat users/groups and
# kernels.
RESTRICT="test"

RDEPEND="ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	dev-lang/swig
	>=sys-kernel/linux-headers-2.6.23"
# Do not use os-headers as this is linux specific

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Old patch applies fine
	#EPATCH_OPTS="-p0 -d${S}" epatch "${FILESDIR}"/${PN}-1.5.4-build.patch

	# Applied by upstream
	#EPATCH_OPTS="-p1 -d${S}" epatch "${FILESDIR}"/${PN}-1.5.4-swig-gcc-attribute.patch

	# Do not build GUI tools
	sed -i \
		-e '/AC_CONFIG_SUBDIRS.*system-config-audit/d' \
		"${S}"/configure.ac
	sed -i \
		-e 's,system-config-audit,,g' \
		-e '/^SUBDIRS/s,\\$,,g' \
		"${S}"/Makefile.am
	rm -rf "${S}"/system-config-audit

	# Probably goes away in 1.6.9
	#EPATCH_OPTS="-p1 -d${S}" epatch "${FILESDIR}"/audit-1.6.8-subdirs-fix.patch

	if ! use ldap; then
		sed -i \
			-e '/^AC_OUTPUT/s,audisp/plugins/zos-remote/Makefile,,g' \
			"${S}"/configure.ac
		sed -i \
			-e '/^SUBDIRS/s,zos-remote,,g' \
			"${S}"/audisp/plugins/Makefile.am
	fi

	# Don't build static version of Python module.
	epatch "${FILESDIR}"/${PN}-1.7.17-python.patch
	# bug #405887
	epatch "${FILESDIR}"/audit-1.7.18-as-needed.patch
	epatch "${FILESDIR}"/audit-1.7.18-missing_headers.patch

	# Regenerate autotooling
	eautoreconf

	# Disable byte-compilation of Python modules.
	echo "#!/bin/sh" > py-compile

	# Bug 352198: Avoid parallel build fail
	cd "${S}"/src/mt
	[[ ! -s private.h ]] && ln -s ../../lib/private.h .
}

src_configure() {
	#append-flags -D'__attribute__(x)='
	econf --sbindir=/sbin --without-prelude
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README* THANKS TODO
	docinto contrib
	dodoc contrib/*
	docinto contrib/plugin
	dodoc contrib/plugin/*

	newinitd "${FILESDIR}"/auditd-init.d-1.7.17 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-1.2.3 auditd

	# things like shadow use this so we need to be in /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/lib*.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libaudit.so libauparse.so

	# remove RedHat garbage
	rm -r "${D}"/etc/{rc.d,sysconfig} || die

	# Gentoo rules
	insinto /etc/audit/
	doins "${FILESDIR}"/audit.rules*

	# audit logs go here
	keepdir /var/log/audit/

	# Security
	lockdown_perms "${D}"

	# Don't install .la files in Python directories.
	python_clean_installation_image
}

pkg_postinst() {
	lockdown_perms "${ROOT}"
	python_mod_optimize audit.py
}

pkg_postrm() {
	python_mod_cleanup audit.py
}

lockdown_perms() {
	# upstream wants these to have restrictive perms
	basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,report,dispd,ditd,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit/ 2>/dev/null
	chmod 0640 "${basedir}"/etc/{audit/,}{auditd.conf,audit.rules*} 2>/dev/null
}
