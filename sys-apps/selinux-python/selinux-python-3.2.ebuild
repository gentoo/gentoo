# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="xml"

inherit python-r1 toolchain-funcs

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN#selinux-}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libselinux-${PV}:=[python]
	>=sys-libs/libsemanage-${PV}:=[python(+)]
	>=sys-libs/libsepol-${PV}:=
	>=app-admin/setools-4.2.0[${PYTHON_USEDEP}]
	>=sys-process/audit-1.5.1[python,${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}"

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
	if [[ -f /etc/selinux/config ]];
	then
		local selinuxtype=$(awk -F'=' '/^SELINUXTYPE/ {print $2}' /etc/selinux/config);
		mkdir -p "${D}"/etc/selinux || die "Failed to create selinux directory";
		echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" > "${D}"/etc/selinux/sepolgen.conf;
	else
		local selinuxtype="${POLICY_TYPES%% *}";
		if [[ -n "${selinuxtype}" ]];
		then
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/${selinuxtype}/include:/usr/share/selinux/${selinuxtype}" > "${D}"/etc/selinux/sepolgen.conf;
		else
			echo "SELINUX_DEVEL_PATH=/usr/share/selinux/strict/include:/usr/share/selinux/strict" > "${D}"/etc/selinux/sepolgen.conf;
		fi
	fi
}
