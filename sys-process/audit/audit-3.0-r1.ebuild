# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit multilib multilib-minimal toolchain-funcs python-r1 linux-info systemd usr-ldscript

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="https://people.redhat.com/sgrubb/audit/"
SRC_URI="https://people.redhat.com/sgrubb/audit/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="gssapi ldap python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# Testcases are pretty useless as they are built for RedHat users/groups and kernels.
RESTRICT="test"

RDEPEND="gssapi? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	sys-libs/libcap-ng
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.34" # This is linux specific.
BDEPEND="python? ( dev-lang/swig:0 )"

CONFIG_CHECK="~AUDIT"

src_prepare() {
	# audisp-remote moved in multilib_src_install_all
	sed -i \
		-e "s,/sbin/audisp-remote,${EPREFIX}/usr/sbin/audisp-remote," \
		audisp/plugins/remote/au-remote.conf || die

	# Disable installing sample rules so they can be installed as docs.
	echo -e '%:\n\t:' | tee rules/Makefile.{am,in} >/dev/null

	default
}

multilib_src_configure() {
	local -a myeconfargs=(
		--sbindir="${EPREFIX}/sbin"
		$(use_enable gssapi gssapi-krb5)
		$(use_enable ldap zos-remote)
		$(use_enable static-libs static)
		--enable-systemd
		--without-golang
		--without-python
		--without-python3
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"

	if multilib_is_native_abi && use python; then
		python_configure() {
			mkdir -p "${BUILD_DIR}"
			pushd "${BUILD_DIR}" &>/dev/null || die
			ECONF_SOURCE=${S} econf "${myeconfargs[@]}" --with-python3
			popd &>/dev/null || die
		}
		python_foreach_impl python_configure
	fi
}

src_configure() {
	tc-export_build_env BUILD_{CC,CPP}
	local -x CC_FOR_BUILD="${BUILD_CC}"
	local -x CPP_FOR_BUILD="${BUILD_CPP}"
	multilib-minimal_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default

		local native_build="${BUILD_DIR}"
		python_compile() {
			emake -C "${BUILD_DIR}"/bindings/swig top_builddir="${native_build}"
			emake -C "${BUILD_DIR}"/bindings/python/python3 top_builddir="${native_build}"
		}
		use python && python_foreach_impl python_compile
	else
		emake -C common
		emake -C lib
		emake -C auparse
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" initdir="$(systemd_get_systemunitdir)" install

		local native_build="${BUILD_DIR}"
		python_install() {
			emake -C "${BUILD_DIR}"/bindings/swig DESTDIR="${D}" top_builddir="${native_build}" install
			emake -C "${BUILD_DIR}"/bindings/python/python3 DESTDIR="${D}" top_builddir="${native_build}" install
			python_optimize
		}
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
	dodoc contrib/avc_snap
	docinto contrib/plugin
	dodoc contrib/plugin/*
	docinto rules
	dodoc rules/*rules

	newinitd "${FILESDIR}"/auditd-init.d-2.4.3 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-2.1.3 auditd

	[ -f "${ED}"/sbin/audisp-remote ] && \
	dodir /usr/sbin && \
	mv "${ED}"/{sbin,usr/sbin}/audisp-remote || die

	# Gentoo rules
	insinto /etc/audit
	newins "${FILESDIR}"/audit.rules-2.1.3 audit.rules
	doins "${FILESDIR}"/audit.rules.stop*

	# audit logs go here
	keepdir /var/log/audit

	find "${ED}" -type f -name '*.la' -delete || die

	# Security
	lockdown_perms "${ED}"
}

pkg_postinst() {
	lockdown_perms "${EROOT}"
}

lockdown_perms() {
	# Upstream wants these to have restrictive perms.
	# Should not || die as not all paths may exist.
	local basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,ditd,report,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit 2>/dev/null
	chmod 0640 "${basedir}"/etc/audit/{auditd.conf,audit*.rules*} 2>/dev/null
}
