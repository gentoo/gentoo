# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit multilib python-r1 toolchain-funcs eutils multilib-minimal

MY_P="${P//_/-}"
MY_RELEASEDATE="20150202"

SEPOL_VER="${PV}"
SELNX_VER="${PV}"

DESCRIPTION="SELinux kernel and policy management library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20150202/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="python"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}[${MULTILIB_USEDEP}]
	>=sys-libs/libselinux-${SELNX_VER}[${MULTILIB_USEDEP}]
	>=sys-process/audit-2.2.2[${MULTILIB_USEDEP}]
	>=dev-libs/ustr-1.0.4-r2[${MULTILIB_USEDEP}]
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	python? (
		>=dev-lang/swig-2.0.4-r1
		virtual/pkgconfig
		${PYTHON_DEPS}
	)"

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

src_prepare() {
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

	if [[ ${PV} != 9999 ]] ; then
		# If wanted for live builds, please use /etc/portage/patches
		epatch "${FILESDIR}/0001-libsemanage-do-not-copy-contexts-in-semanage_migrate.patch"
	fi

	epatch_user

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
			python_export PYTHON_INCLUDEDIR PYTHON_LIBPATH
			emake CC="$(tc-getCC)" PYINC="-I${PYTHON_INCLUDEDIR}" PYTHONLBIDIR="${PYTHON_LIBPATH}" PYPREFIX="${EPYTHON##*/}" "$@"
		}
		python_foreach_impl building_py swigify
		python_foreach_impl building_py pywrap
	fi
}

multilib_src_install() {
	emake \
		LIBDIR="${ED}/usr/$(get_libdir)" \
		SHLIBDIR="${ED}/usr/$(get_libdir)" \
		DESTDIR="${ED}" install

	if multilib_is_native_abi && use python; then
		installation_py() {
			emake DESTDIR="${ED}" LIBDIR="${ED}/usr/$(get_libdir)" \
				SHLIBDIR="${ED}/usr/$(get_libdir)" install-pywrap
			python_optimize # bug 531638
		}
		python_foreach_impl installation_py
	fi
}

pkg_postinst() {
	# Migrate the SELinux semanage configuration store if not done already
	local selinuxtype=$(awk -F'=' '/SELINUXTYPE=/ {print $2}' /etc/selinux/config);
	if [ -n "${selinuxtype}" ] && [ ! -d /var/lib/selinux/${mcs}/active ] ; then
		ewarn "Since the 2.4 SELinux userspace, the policy module store is moved"
		ewarn "from /etc/selinux to /var/lib/selinux. The migration will be run now."
		ewarn "If there are any issues, it can be done manually by running:"
		ewarn "/usr/libexec/selinux/semanage_migrate_store"
		ewarn "For more information, please see"
		ewarn "- https://github.com/SELinuxProject/selinux/wiki/Policy-Store-Migration"
	fi

	# Run the store migration without rebuilds
	for POLICY_TYPE in ${POLICY_TYPES} ; do
		if [ ! -d "${ROOT}/var/lib/selinux/${POLICY_TYPE}/active" ] ; then
			einfo "Migrating store ${POLICY_TYPE} (without policy rebuild)."
			/usr/libexec/selinux/semanage_migrate_store -n -s "${POLICY_TYPE}" || die "Failed to migrate store ${POLICY_TYPE}"
		fi
	done
}
