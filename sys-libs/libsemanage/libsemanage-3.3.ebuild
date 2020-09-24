# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit python-r1 toolchain-funcs multilib-minimal

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SELinux kernel and policy management library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~mips ~riscv x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0/2"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=sys-libs/libsepol-${PV}:=[${MULTILIB_USEDEP}]
	>=sys-libs/libselinux-${PV}:=[${MULTILIB_USEDEP}]
	>=sys-process/audit-2.2.2[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/swig-2.0.4-r1
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

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
	local -x CFLAGS="${CFLAGS} -fno-semantic-interposition"

	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		all

	if multilib_is_native_abi; then
		building_py() {
			emake \
				AR="$(tc-getAR)" \
				CC="$(tc-getCC)" \
				PKG_CONFIG="$(tc-getPKG_CONFIG)" \
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

	if multilib_is_native_abi; then
		installation_py() {
			emake DESTDIR="${ED}" \
				LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
				PKG_CONFIG="$(tc-getPKG_CONFIG)" \
				install-pywrap
			python_optimize # bug 531638
		}
		python_foreach_impl installation_py
	fi
}

multiib_src_install_all() {
	python_setup
	python_fix_shebang "${ED}"/usr/libexec/selinux/semanage_migrate_store
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
}
