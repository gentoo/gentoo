# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="xml"

inherit python-r1 toolchain-funcs

MY_P="${P//_/-}"

MY_RELEASEDATE="20161014"
SEPOL_VER="${PV}"
SELNX_VER="${PV}"
SEMNG_VER="${PV}"

IUSE="audit pam dbus"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN#selinux-}"
else
	SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libselinux-${SELNX_VER}:=[python]
	>=sys-libs/libsemanage-${SEMNG_VER}:=[python]
	>=sys-libs/libsepol-${SEPOL_VER}:=
	>=app-admin/setools-4.0
	dev-python/ipy[${PYTHON_USEDEP}]
	!dev-python/sepolgen
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
			PYLIBVER="${EPYTHON}" \
			LIBDIR="\$(PREFIX)/$(get_libdir)"
	}
	python_foreach_impl building
}

src_install() {
	installation() {
		emake -C "${BUILD_DIR}" \
			DESTDIR="${D}" \
			LIBDIR="\$(PREFIX)/$(get_libdir)" \
			LIBSEPOLA="/usr/$(get_libdir)/libsepol.a" \
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
