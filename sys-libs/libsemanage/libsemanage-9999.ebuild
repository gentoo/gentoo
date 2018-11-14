# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit multilib python-r1 toolchain-funcs multilib-minimal

MY_P="${P//_/-}"
MY_RELEASEDATE="20180524"

SEPOL_VER="${PV}"
SELNX_VER="${PV}"

DESCRIPTION="SELinux kernel and policy management library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}[${MULTILIB_USEDEP}]
	>=sys-libs/libselinux-${SELNX_VER}[${MULTILIB_USEDEP}]
	>=sys-process/audit-2.2.2[${MULTILIB_USEDEP}]
	>=dev-libs/ustr-1.0.4-r2[${MULTILIB_USEDEP}]
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	python? (
		>=dev-lang/swig-2.0.4-r1
		virtual/pkgconfig
	)"

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

src_prepare() {
	eapply_user

	echo >> "${S}/src/semanage.conf"
	echo "# Set this to true to save the linked policy." >> "${S}/src/semanage.conf"
	echo "# This is normally only useful for analysis" >> "${S}/src/semanage.conf"
	echo "# or debugging of policy." >> "${S}/src/semanage.conf"
	echo "save-linked=false" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Set this to 0 to disable assertion checking." >> "${S}/src/semanage.conf"
	echo "# This should speed up building the kernel policy" >> "${S}/src/semanage.conf"
	echo "# from policy modules, but may leave you open to" >> "${S}/src/semanage.conf"
	echo "# dangerous rules which assertion checking" >> "${S}/src/semanage.conf"
	echo "# would catch." >> "${S}/src/semanage.conf"
	echo "expand-check=1" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Modules in the module store can be compressed" >> "${S}/src/semanage.conf"
	echo "# with bzip2.  Set this to the bzip2 blocksize" >> "${S}/src/semanage.conf"
	echo "# 1-9 when compressing.  The higher the number," >> "${S}/src/semanage.conf"
	echo "# the more memory is traded off for disk space." >> "${S}/src/semanage.conf"
	echo "# Set to 0 to disable bzip2 compression." >> "${S}/src/semanage.conf"
	echo "bzip-blocksize=0" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Reduce memory usage for bzip2 compression and" >> "${S}/src/semanage.conf"
	echo "# decompression of modules in the module store." >> "${S}/src/semanage.conf"
	echo "bzip-small=true" >> "${S}/src/semanage.conf"

	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		all

	if multilib_is_native_abi && use python; then
		building_py() {
			emake \
				AR="$(tc-getAR)" \
				CC="$(tc-getCC)" \
				LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
				"$@"
		}
		python_foreach_impl building_py swigify
		python_foreach_impl building_py pywrap
	fi
}

multilib_src_install() {
	emake \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${ED}" install

	if multilib_is_native_abi && use python; then
		installation_py() {
			emake DESTDIR="${ED}" \
				LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
				install-pywrap
			python_optimize # bug 531638
		}
		python_foreach_impl installation_py
	fi
}

pkg_postinst() {
	# Migrate the SELinux semanage configuration store if not done already
	local selinuxtype=$(awk -F'=' '/SELINUXTYPE=/ {print $2}' "${EROOT}"/etc/selinux/config 2>/dev/null)
	if [ -n "${selinuxtype}" ] && [ ! -d "${EROOT}"/var/lib/selinux/${selinuxtype}/active ] ; then
		ewarn "Since the 2.4 SELinux userspace, the policy module store is moved"
		ewarn "from /etc/selinux to /var/lib/selinux. The migration will be run now."
		ewarn "If there are any issues, it can be done manually by running:"
		ewarn "/usr/libexec/selinux/semanage_migrate_store"
		ewarn "For more information, please see"
		ewarn "- https://github.com/SELinuxProject/selinux/wiki/Policy-Store-Migration"
	fi

	# Run the store migration without rebuilds
	for POLICY_TYPE in ${POLICY_TYPES} ; do
		if [ ! -d "${EROOT}/var/lib/selinux/${POLICY_TYPE}/active" ] ; then
			einfo "Migrating store ${POLICY_TYPE} (without policy rebuild)."
			"${EROOT}/usr/libexec/selinux/semanage_migrate_store" -n -s "${POLICY_TYPE}" || die "Failed to migrate store ${POLICY_TYPE}"
		fi
	done
}
