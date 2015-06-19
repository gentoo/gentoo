# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/audit-2.1.3-r1.ebuild,v 1.18 2013/03/03 10:25:39 vapier Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit autotools multilib toolchain-funcs python linux-info eutils

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="http://people.redhat.com/sgrubb/audit/"
SRC_URI="http://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="ldap prelude python"
# Testcases are pretty useless as they are built for RedHat users/groups and
# kernels.
RESTRICT="test"

RDEPEND="ldap? ( net-nds/openldap )
		 prelude? ( dev-libs/libprelude )
		 sys-libs/libcap-ng"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	>=sys-kernel/linux-headers-2.6.34"
# Do not use os-headers as this is linux specific

CONFIG_CHECK="~AUDIT"
PYTHON_DIRS="bindings/python swig"

pkg_setup() {
	linux-info_pkg_setup
	use python && python_pkg_setup
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
	epatch "${FILESDIR}"/${PN}-2.1.3-python.patch

	# glibc/kernel upstreams suck with both defining ia64_fpreg
	# This patch is a horribly workaround that is only valid as long as you
	# don't need the OTHER definitions in fpu.h.
	epatch "${FILESDIR}"/${PN}-2.1.3-ia64-compile-fix.patch

	# Python bindings are built/installed manually.
	sed -e "/^SUBDIRS =/s/ python//" -i bindings/Makefile.am
	sed -e "/^SUBDIRS .*=/s/ swig//" -i Makefile.am

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

src_compile_python() {
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

src_compile() {
	default
	use python && src_compile_python
}

src_install_python() {
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
}

src_install() {
	emake DESTDIR="${D}" install || die
	use python && src_install_python

	dodoc AUTHORS ChangeLog README* THANKS TODO
	docinto contrib
	dodoc contrib/{*.rules,avc_snap,skeleton.c}
	docinto contrib/plugin
	dodoc contrib/plugin/*

	newinitd "${FILESDIR}"/auditd-init.d-2.1.3 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-2.1.3 auditd

	# things like shadow use this so we need to be in /
	gen_usr_ldscript -a audit auparse

	[ -f "${D}"/sbin/audisp-remote ] && \
	dodir /usr/sbin && \
	mv "${D}"/{sbin,usr/sbin}/audisp-remote || die

	# remove RedHat garbage
	rm -r "${D}"/etc/{rc.d,sysconfig} || die

	# Gentoo rules
	insinto /etc/audit/
	newins "${FILESDIR}"/audit.rules-2.1.3 audit.rules
	doins "${FILESDIR}"/audit.rules.stop*

	# audit logs go here
	keepdir /var/log/audit/

	# Security
	lockdown_perms "${D}"

	# Don't install .la files in Python directories.
	use python && python_clean_installation_image
}

pkg_preinst() {
	# Preserve from the audit-1 series
	preserve_old_lib /$(get_libdir)/libau{dit,parse}.so.0
}

pkg_postinst() {
	lockdown_perms "${ROOT}"
	use python && python_mod_optimize audit.py
	# Preserve from the audit-1 series
	preserve_old_lib_notify /$(get_libdir)/libau{dit,parse}.so.0
}

pkg_postrm() {
	use python && python_mod_cleanup audit.py
}

lockdown_perms() {
	# upstream wants these to have restrictive perms
	basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,report,dispd,ditd,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit/ 2>/dev/null
	chmod 0640 "${basedir}"/etc/{audit/,}{auditd.conf,audit.rules*} 2>/dev/null
}
