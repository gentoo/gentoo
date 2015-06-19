# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/audit-2.4.1-r1.ebuild,v 1.1 2015/05/16 05:56:03 robbat2 Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit autotools multilib multilib-minimal toolchain-funcs python-r1 linux-info eutils systemd

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="http://people.redhat.com/sgrubb/audit/"
SRC_URI="http://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="ldap python"
# Testcases are pretty useless as they are built for RedHat users/groups and
# kernels.
RESTRICT="test"

RDEPEND="ldap? ( net-nds/openldap )
		 sys-libs/libcap-ng"
DEPEND="${RDEPEND}
	python? ( ${PYTHON_DEPS}
		dev-lang/swig )
	>=sys-kernel/linux-headers-2.6.34"
# Do not use os-headers as this is linux specific

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CONFIG_CHECK="~AUDIT"

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	# Do not build GUI tools
	sed -i \
		-e '/AC_CONFIG_SUBDIRS.*system-config-audit/d' \
		"${S}"/configure.ac || die
	sed -i \
		-e 's,system-config-audit,,g' \
		"${S}"/Makefile.am || die
	rm -rf "${S}"/system-config-audit

	if ! use ldap; then
		sed -i \
			-e '/^AC_OUTPUT/s,audisp/plugins/zos-remote/Makefile,,g' \
			"${S}"/configure.ac || die
		sed -i \
			-e '/^SUBDIRS/s,zos-remote,,g' \
			"${S}"/audisp/plugins/Makefile.am || die
	fi

	# Don't build static version of Python module.
	epatch "${FILESDIR}"/${PN}-2.4.1-python.patch

	# glibc/kernel upstreams suck with both defining ia64_fpreg
	# This patch is a horribly workaround that is only valid as long as you
	# don't need the OTHER definitions in fpu.h.
	epatch "${FILESDIR}"/${PN}-2.1.3-ia64-compile-fix.patch

	# Python bindings are built/installed manually.
	sed -e "/^SUBDIRS =/s/ python//" -i bindings/Makefile.am
	sed -e "/^SUBDIRS .*=/s/ swig//" -i Makefile.am

	# Regenerate autotooling
	eautoreconf

	# Bug 352198: Avoid parallel build fail
	cd "${S}"/src/mt
	[[ ! -s private.h ]] && ln -s ../../lib/private.h .
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	#append-flags -D'__attribute__(x)='
	econf \
		--sbindir=/sbin \
		--enable-systemd \
		--without-python

	if multilib_is_native_abi; then
		python_configure() {
			mkdir -p "${BUILD_DIR}" || die
			cd "${BUILD_DIR}" || die
			econf --with-python
		}

		use python && python_foreach_impl python_configure
	fi
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default

		python_compile() {
			emake -C "${BUILD_DIR}"/swig \
				VPATH="${native_build}/lib" \
				LIBS="${native_build}/lib/libaudit.la"
			emake -C "${BUILD_DIR}"/bindings/python \
				VPATH="${S}/bindings/python:${native_build}/bindings/python" \
				auparse_la_LIBADD="${native_build}/auparse/libauparse.la ${native_build}/lib/libaudit.la"
		}

		local native_build=${BUILD_DIR}
		use python && python_foreach_impl python_compile
	else
		emake -C lib
		emake -C auparse
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" initdir="$(systemd_get_unitdir)" install

		python_install() {
			emake -C "${BUILD_DIR}"/swig \
				VPATH="${native_build}/lib" \
				DESTDIR="${D}" install
			emake -C "${BUILD_DIR}"/bindings/python \
				VPATH="${S}/bindings/python:${native_build}/bindings/python" \
				DESTDIR="${D}" install
		}

		local native_build=${BUILD_DIR}
		use python && python_foreach_impl python_install

		# things like shadow use this so we need to be in /
		gen_usr_ldscript -a audit auparse
	else
		emake -C lib DESTDIR="${D}" install
		emake -C auparse DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog README* THANKS TODO
	docinto contrib
	dodoc contrib/{*.rules,avc_snap,skeleton.c}
	docinto contrib/plugin
	dodoc contrib/plugin/*

	newinitd "${FILESDIR}"/auditd-init.d-2.1.3 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-2.1.3 auditd

	[ -f "${D}"/sbin/audisp-remote ] && \
	dodir /usr/sbin && \
	mv "${D}"/{sbin,usr/sbin}/audisp-remote || die

	# Gentoo rules
	insinto /etc/audit/
	newins "${FILESDIR}"/audit.rules-2.1.3 audit.rules
	doins "${FILESDIR}"/audit.rules.stop*

	# audit logs go here
	keepdir /var/log/audit/

	# Security
	lockdown_perms "${D}"

	prune_libtool_files --modules
}

pkg_preinst() {
	# Preserve from the audit-1 series
	preserve_old_lib /$(get_libdir)/libaudit.so.0
}

pkg_postinst() {
	lockdown_perms "${ROOT}"
	# Preserve from the audit-1 series
	preserve_old_lib_notify /$(get_libdir)/libaudit.so.0
}

lockdown_perms() {
	# upstream wants these to have restrictive perms
	basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,report,dispd,ditd,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit/ 2>/dev/null
	chmod 0640 "${basedir}"/etc/{audit/,}{auditd.conf,audit.rules*} 2>/dev/null
}
