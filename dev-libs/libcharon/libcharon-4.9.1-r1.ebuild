# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit cmake python-single-r1

MY_PN="libCharon"

DESCRIPTION="This library facilitates communication between Cura and its backend"
HOMEPAGE="https://github.com/Ultimaker/libCharon"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="+client +dbus test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="
	${PYTHON_DEPS}
	dbus? (
		acct-group/ultimaker
		acct-user/ultimaker
		sys-apps/dbus
	)"

DEPEND="${PYTHON_DEPS}
	test? (
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# use current python version, not the latest installed
	# fix python install location
	sed -i \
		-e "s:find_package(Python3 3.4 REQUIRED:find_package(Python3 ${EPYTHON##python} EXACT REQUIRED:g" \
		-e "s:lib\${LIB_SUFFIX}/python\${Python3_VERSION_MAJOR}\.\${Python3_VERSION_MINOR}/site-packages:$(python_get_sitedir):g" \
		CMakeLists.txt || die

	sed -i -e "s:/usr/lib/python3/dist-packages/Charon/Service/main.py:$(python_get_sitedir)/Charon/Service/main.py:g" service/charon.service || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_CLIENT=$(usex client ON OFF)
		-DINSTALL_SERVICE=$(usex dbus ON OFF)
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}

pkg_postinst() {
	if use dbus ; then
		elog "To start the Charon File Metadata service at boot, add it to the default runlevel with:"
		elog "    systemctl enable charon"
	fi
}
