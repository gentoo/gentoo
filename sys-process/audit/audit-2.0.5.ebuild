# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit autotools multilib toolchain-funcs python linux-info eutils

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="https://people.redhat.com/sgrubb/audit/"
SRC_URI="https://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ldap prelude"
# Testcases are pretty useless as they are built for RedHat users/groups and
# kernels.
RESTRICT="test"

RDEPEND="ldap? ( net-nds/openldap )
		 prelude? ( dev-libs/libprelude )
		 sys-libs/libcap-ng"
DEPEND="${RDEPEND}
	dev-lang/swig
	>=sys-kernel/linux-headers-2.6.34"
# Do not use os-headers as this is linux specific

CONFIG_CHECK="~AUDIT"

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
	PYTHON_DIRS="bindings/python swig"
}

src_prepare() {
	# Old patch applies fine
	#EPATCH_OPTS="-p0 -d${S}" epatch "${FILESDIR}"/${PN}-1.5.4-build.patch

	# Applied by upstream
	#EPATCH_OPTS="-p1 -d${S}" epatch "${FILESDIR}"/${PN}-1.5.4-swig-gcc-attribute.patch

	# Do not build GUI tools
	sed -i \
		-e '/AC_CONFIG_SUBDIRS.*system-config-audit/d' \
		"${S}"/configure.ac || die
	sed -i \
		-e 's,system-config-audit,,g' \
		-e '/^SUBDIRS/s,\\$,,g' \
		"${S}"/Makefile.am || die
	rm -rf "${S}"/system-config-audit

	# Probably goes away in 1.6.9
	#EPATCH_OPTS="-p1 -d${S}" epatch "${FILESDIR}"/audit-1.6.8-subdirs-fix.patch

	if ! use ldap; then
		sed -i \
			-e '/^AC_OUTPUT/s,audisp/plugins/zos-remote/Makefile,,g' \
			"${S}"/configure.ac || die
		sed -i \
			-e '/^SUBDIRS/s,zos-remote,,g' \
			"${S}"/audisp/plugins/Makefile.am || die
	fi

	# Don't build static version of Python module.
	epatch "${FILESDIR}"/${P}-python.patch

	# Python bindings are built/installed manually.
	sed -e "/^SUBDIRS =/s/ python//" -i bindings/Makefile.am
	sed -e "/^SUBDIRS =/s/ swig//" -i Makefile.am

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
	econf --sbindir=/sbin $(use_with prelude)
}

src_compile() {
	default

	python_copy_sources ${PYTHON_DIRS}

	building() {
		emake \
			PYTHON_VERSION="$(python_get_version)" \
			pyexecdir="$(python_get_sitedir)"
	}
	local dir
	for dir in ${PYTHON_DIRS}; do
		python_execute_function -s --source-dir ${dir} building
	done
}

src_install() {
	emake DESTDIR="${D}" install || die

	installation() {
		emake \
			DESTDIR="${D}" \
			PYTHON_VERSION="$(python_get_version)" \
			pyexecdir="$(python_get_sitedir)" \
			install
	}
	local dir
	for dir in ${PYTHON_DIRS}; do
		python_execute_function -s --source-dir ${dir} installation
	done

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

pkg_preinst() {
	default
	# Preserve from the audit-1 series
	preserve_old_lib /$(get_libdir)/libau{dit,parse}.so.0
}

pkg_postinst() {
	lockdown_perms "${ROOT}"
	python_mod_optimize audit.py
	# Preserve from the audit-1 series
	preserve_old_lib_notify /$(get_libdir)/libau{dit,parse}.so.0
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
