# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools multilib multilib-minimal toolchain-funcs preserve-libs python-r1 linux-info systemd

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="https://people.redhat.com/sgrubb/audit/"
SRC_URI="https://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="gssapi ldap python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# Testcases are pretty useless as they are built for RedHat users/groups and kernels.
RESTRICT="test"

RDEPEND="gssapi? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	sys-libs/libcap-ng
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.34
	python? ( dev-lang/swig:0 )"
# Do not use os-headers as this is linux specific

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
	eapply "${FILESDIR}"/${PN}-2.4.3-python.patch

	# glibc/kernel upstreams suck with both defining ia64_fpreg
	# This patch is a horribly workaround that is only valid as long as you
	# don't need the OTHER definitions in fpu.h.
	eapply "${FILESDIR}"/${PN}-2.8.4-ia64-compile-fix.patch

	# there is no --without-golang conf option
	sed -e "/^SUBDIRS =/s/ @gobind_dir@//" -i bindings/Makefile.am || die

	eapply_user

	# Regenerate autotooling
	eautoreconf
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	econf \
		--sbindir="${EPREFIX}/sbin" \
		$(use_enable gssapi gssapi-krb5) \
		$(use_enable static-libs static) \
		--enable-systemd \
		--without-python \
		--without-python3

	if multilib_is_native_abi; then
		python_configure() {
			mkdir -p "${BUILD_DIR}" || die
			cd "${BUILD_DIR}" || die

			if python_is_python3; then
				econf --without-python --with-python3
			else
				econf --with-python --without-python3
			fi
		}

		use python && python_foreach_impl python_configure
	fi
}

src_configure() {
	tc-export_build_env BUILD_{CC,CPP}
	export CC_FOR_BUILD="${BUILD_CC}"
	export CPP_FOR_BUILD="${BUILD_CPP}"

	multilib-minimal_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default

		python_compile() {
			local pysuffix pydef
			if python_is_python3; then
				pysuffix=3
				pydef='USE_PYTHON3=true'
			else
				pysuffix=2
				pydef='HAVE_PYTHON=true'
			fi

			emake -C "${BUILD_DIR}"/bindings/swig \
				VPATH="${native_build}/lib" \
				LIBS="${native_build}/lib/libaudit.la" \
				_audit_la_LIBADD="${native_build}/lib/libaudit.la" \
				_audit_la_DEPENDENCIES="${S}/lib/libaudit.h ${native_build}/lib/libaudit.la" \
				${pydef}
			emake -C "${BUILD_DIR}"/bindings/python/python${pysuffix} \
				VPATH="${S}/bindings/python/python${pysuffix}:${native_build}/bindings/python/python${pysuffix}" \
				auparse_la_LIBADD="${native_build}/auparse/libauparse.la ${native_build}/lib/libaudit.la" \
				${pydef}
		}

		local native_build="${BUILD_DIR}"
		use python && python_foreach_impl python_compile
	else
		emake -C lib
		emake -C auparse
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" initdir="$(systemd_get_systemunitdir)" install

		python_install() {
			local pysuffix pydef
			if python_is_python3; then
				pysuffix=3
				pydef='USE_PYTHON3=true'
			else
				pysuffix=2
				pydef='HAVE_PYTHON=true'
			fi

			emake -C "${BUILD_DIR}"/bindings/swig \
				VPATH="${native_build}/lib" \
				LIBS="${native_build}/lib/libaudit.la" \
				_audit_la_LIBADD="${native_build}/lib/libaudit.la" \
				_audit_la_DEPENDENCIES="${S}/lib/libaudit.h ${native_build}/lib/libaudit.la" \
				${pydef} \
				DESTDIR="${D}" install
			emake -C "${BUILD_DIR}"/bindings/python/python${pysuffix} \
				VPATH="${S}/bindings/python/python${pysuffix}:${native_build}/bindings/python/python${pysuffix}" \
				auparse_la_LIBADD="${native_build}/auparse/libauparse.la ${native_build}/lib/libaudit.la" \
				${pydef} \
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
	dodoc AUTHORS ChangeLog README* THANKS
	docinto contrib
	dodoc contrib/{avc_snap,skeleton.c}
	docinto contrib/plugin
	dodoc contrib/plugin/*
	docinto rules
	dodoc rules/*

	newinitd "${FILESDIR}"/auditd-init.d-2.4.3 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-2.1.3 auditd

	fperms 644 "$(systemd_get_systemunitdir)"/auditd.service # 556436

	[ -f "${ED}"/sbin/audisp-remote ] && \
	dodir /usr/sbin && \
	mv "${ED}"/{sbin,usr/sbin}/audisp-remote || die

	# Gentoo rules
	insinto /etc/audit/
	newins "${FILESDIR}"/audit.rules-2.1.3 audit.rules
	doins "${FILESDIR}"/audit.rules.stop*

	# audit logs go here
	keepdir /var/log/audit/

	find "${D}" -name '*.la' -delete || die

	# Security
	lockdown_perms "${ED}"
}

pkg_preinst() {
	# Preserve from the audit-1 series
	preserve_old_lib /$(get_libdir)/libaudit.so.0
}

pkg_postinst() {
	lockdown_perms "${EROOT}"
	# Preserve from the audit-1 series
	preserve_old_lib_notify /$(get_libdir)/libaudit.so.0
}

lockdown_perms() {
	# Upstream wants these to have restrictive perms.
	# Should not || die as not all paths may exist.
	local basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,report,dispd,ditd,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit/ 2>/dev/null
	chmod 0640 "${basedir}"/etc/{audit/,}{auditd.conf,audit.rules*} 2>/dev/null
}
