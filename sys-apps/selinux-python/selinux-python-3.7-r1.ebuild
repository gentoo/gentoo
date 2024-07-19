# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"

inherit python-r1 toolchain-funcs

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN#selinux-}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=sys-libs/libselinux-${PV}:=[python]
	>=sys-libs/libsemanage-${PV}:=[python(+)]
	>=sys-libs/libsepol-${PV}:=[static-libs(+)]
	>=app-admin/setools-4.2.0[${PYTHON_USEDEP}]
	>=sys-process/audit-1.5.1[python,${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		${RDEPEND}
		>=sys-apps/secilc-${PV}
	)"

src_prepare() {
	default
	sed -i 's/-Werror//g' "${S}"/*/Makefile || die "Failed to remove Werror"

	python_copy_sources
}

src_compile() {
	building() {
		emake -C "${BUILD_DIR}" \
			CC="$(tc-getCC)" \
			LIBDIR="\$(PREFIX)/$(get_libdir)"
	}
	python_foreach_impl building
}

src_test() {
	testing() {
		# The different subprojects have some interproject dependencies:
		# - audit2allow depens on sepolgen
		# - chcat depends on semanage
		# and maybe others.
		# Add all the modules of the individual subprojects to the
		# PYTHONPATH, so they get actually found and used. In
		# particular, already installed versions on the system are not
		# used.
		for dir in audit2allow chcat semanage sepolgen/src sepolicy ; do
			PYTHONPATH="${BUILD_DIR}/${dir}:${PYTHONPATH}"
		done
		PYTHONPATH=${PYTHONPATH} \
			emake -C "${BUILD_DIR}" \
				test
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		emake -C "${BUILD_DIR}" \
			DESTDIR="${D}" \
			LIBDIR="\$(PREFIX)/$(get_libdir)" \
			install
		python_optimize
	}
	python_foreach_impl installation

	# Set version-specific scripts
	for pyscript in audit2allow sepolgen-ifgen sepolicy chcat; do
		python_replicate_script "${ED}/usr/bin/${pyscript}"
	done
	for pyscript in semanage; do
		python_replicate_script "${ED}/usr/sbin/${pyscript}"
	done

	# Create sepolgen.conf with different devel location definition
	mkdir -p "${D}"/etc/selinux || die "Failed to create selinux directory";
	if [[ -f /etc/selinux/config ]];
	then
		local selinuxtype=$(awk -F'=' '/^SELINUXTYPE/ {print $2}' /etc/selinux/config);
		echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" \
			> "${D}"/etc/selinux/sepolgen.conf || die "Failed to generate sepolgen"
	else
		local selinuxtype="${POLICY_TYPES%% *}";
		if [[ -n "${selinuxtype}" ]];
		then
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" \
				> "${D}"/etc/selinux/sepolgen.conf || die "Failed to generate sepolgen"
		else
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/strict/include:/usr/share/selinux/strict" \
				> "${D}"/etc/selinux/sepolgen.conf || die "Failed to generate sepolgen"
		fi
	fi
}
