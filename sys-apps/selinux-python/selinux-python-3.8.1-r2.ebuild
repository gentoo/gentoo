# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 toolchain-funcs

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
	KEYWORDS="amd64 arm arm64 ~riscv x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=sys-libs/libselinux-${PV}:=[python]
	>=sys-libs/libsemanage-${PV}:=[python(+)]
	>=sys-libs/libsepol-${PV}:=[static-libs(+)]
	>=app-admin/setools-4.2.0[${PYTHON_USEDEP}]
	>=sys-process/audit-1.5.1[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		${RDEPEND}
		sec-policy/selinux-base
		>=sys-apps/secilc-${PV}
	)"

PATCHES=(
	"${FILESDIR}"/selinux-python-3.8.1-no-pip.patch
)

src_prepare() {
	default

	sed -e 's/-Werror//g' -i "${S}"/*/Makefile || die "Failed to remove Werror"

	pushd sepolicy >/dev/null || die
	# To avoid default
	DISTUTILS_OPTIONAL=1 distutils-r1_src_prepare
	popd >/dev/null || die
}

python_compile() {
	distutils-r1_python_compile
	emake -C "${S}" \
		CC="$(tc-getCC)" \
		LIBDIR="\$(PREFIX)/$(get_libdir)"
}

src_compile() {
	pushd sepolicy >/dev/null || die
	distutils-r1_src_compile
	popd >/dev/null || die
}

python_test() {
	# The different subprojects have some interproject dependencies:
	# - audit2allow depens on sepolgen
	# - chcat depends on semanage
	# and maybe others.
	# Add all the modules of the individual subprojects to the
	# PYTHONPATH, so they get actually found and used. In
	# particular, already installed versions on the system are not
	# used.
	for dir in audit2allow chcat semanage sepolgen/src sepolicy ; do
		PYTHONPATH="${S}/${dir}:${PYTHONPATH}"
	done
	PYTHONPATH=${PYTHONPATH} emake -C "${S}" test
}

src_test() {
	pushd sepolicy >/dev/null || die
	distutils-r1_src_test
	popd >/dev/null || die
}

python_install() {
	distutils-r1_python_install
	emake -C "${S}" \
		DESTDIR="${D}" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		install

	# Install over previously installed scripts to ensure proper python support
	python_doscript "${S}"/audit2allow/audit2allow
	python_doscript "${S}"/audit2allow/sepolgen-ifgen
	python_doscript "${S}"/chcat/chcat
	python_newscript "${S}"/sepolicy/sepolicy.py sepolicy

	python_scriptinto /usr/sbin
	python_doscript "${S}"/semanage/semanage

	# set _PYTHON_SCRIPTROOT to the implicit default for the next python target, bug #967869
	python_scriptinto /usr/bin

	python_optimize
}

python_install_all() {
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

src_install() {
	pushd sepolicy >/dev/null || die
	distutils-r1_src_install
	popd >/dev/null || die
}
