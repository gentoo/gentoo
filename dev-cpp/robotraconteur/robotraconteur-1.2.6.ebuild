# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-r1

DESCRIPTION="Robot Raconteur C++ library with Python bindings"
HOMEPAGE="https://github.com/robotraconteur/robotraconteur"
SRC_URI="https://github.com/robotraconteur/robotraconteur/releases/download/v${PV}/RobotRaconteur-${PV}-Source.tar.gz"

S="${WORKDIR}/RobotRaconteur-${PV}-Source"

LICENSE="Apache-2.0"
SLOT="1/${PV}"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="python"

DEPEND="dev-libs/boost
    dev-libs/openssl
    dev-libs/libusb
    sys-apps/dbus
    net-wireless/bluez
    dev-build/cmake
    python? ( dev-python/numpy[${PYTHON_USEDEP}]
              dev-python/setuptools[${PYTHON_USEDEP}]
              dev-python/pip[${PYTHON_USEDEP}] )
"
RDEPEND="
    ${DEPEND}
    python? (
		${PYTHON_DEPS}
    )
"

REQUIRED_USE="
    python? ( ${PYTHON_REQUIRED_USE} )
"

python_configure() {
    local mycmakeargs=(
        -DCMAKE_SKIP_RPATH=ON
        -DBUILD_GEN=ON
        -DBUILD_TESTING=OFF
        -DBUILD_DOCUMENTATION=OFF
        -DBUILD_PYTHON3=ON
        -DINSTALL_PYTHON3_PIP=ON
        -DINSTALL_PYTHON3_PIP_EXTRA_ARGS="--compile --use-pep517 --no-build-isolation --no-deps --root-user-action=ignore"
        -DROBOTRACONTEURCORE_SOVERSION_MAJOR_ONLY=ON
    )
    cmake_src_configure
}

src_configure() {
    if use python; then
        python_foreach_impl python_configure
    else
        local mycmakeargs=(
            -DCMAKE_SKIP_RPATH=ON
            -DBUILD_GEN=ON
            -DBUILD_TESTING=OFF
            -DBUILD_DOCUMENTATION=OFF
            -DROBOTRACONTEURCORE_SOVERSION_MAJOR_ONLY=ON
        )
        cmake_src_configure
    fi
}

src_compile() {
    if use python; then
        python_foreach_impl cmake_src_compile
    else
        cmake_src_compile
    fi
}

python_install(){
    cmake_src_install
    python_optimize "${D}$(python_get_sitedir)/RobotRaconteur" || die "Failed to optimize Python files"
}

src_install() {
    if use python; then
        python_foreach_impl python_install
    else
        cmake_src_install
    fi
}
