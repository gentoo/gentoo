# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 meson cmake

SDP="systemd-stable-250.4"
DESCRIPTION="High-level C++ D-Bus library"
HOMEPAGE="https://github.com/Kistler-Group/sdbus-cpp"
SRC_URI="https://github.com/Kistler-Group/sdbus-cpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	!systemd? ( https://github.com/systemd/systemd/archive/v${SDP##*-}/${SDP}.tar.gz )"
LICENSE="LGPL-2.1+ Nokia-Qt-LGPL-Exception-1.1" # Nothing to do with Qt but exception text is exactly the same.
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="doc systemd test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	!systemd? ( sys-libs/libcap )
	systemd? ( >=sys-apps/systemd-236:= )
	tools? ( dev-libs/expat )
"

# util-linux is needed for libmount when building libsystemd, but sdbus-c++
# doesn't need it when subsequently linking libsystemd statically.

DEPEND="
	${RDEPEND}
	!systemd? ( sys-apps/util-linux )
	test? ( >=dev-cpp/gtest-1.10.0 )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	!systemd? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

S="${WORKDIR}/sdbus-cpp-${PV}"
SDS="${WORKDIR}/${SDP}"
SDB="${WORKDIR}/systemd-build"

PATCHES=(
	"${FILESDIR}"/${PN}-gtest-1.11.patch
)

pkg_setup() {
	use systemd || python-any-r1_pkg_setup
}

src_prepare() {
	if ! use systemd; then
		pushd "${SDS}" || die
		eapply "${FILESDIR}"/${PN}-static-libsystemd.patch
		popd || die
	fi

	cmake_src_prepare
}

src_configure() {
	if ! use systemd; then
		EMESON_SOURCE=${SDS} \
		BUILD_DIR=${SDB} \
		meson_src_configure \
			--prefix "${WORKDIR}" \
			--includedir "${SDP}/src" \
			-Drootlibdir="${SDB}" \
			-Dselinux=false \
			-Dstatic-libsystemd=pic

		# systemd doesn't generate the needed pkg-config file during configure.
		BUILD_DIR=${SDB} \
		meson_src_compile libsystemd.pc

		# Need this present otherwise CMake generates the wrong linker args.
		touch "${SDB}"/libsystemd.a || die
	fi

	local mycmakeargs=(
		-DBUILD_CODE_GEN=$(usex tools)
		-DBUILD_DOC=yes
		-DBUILD_DOXYGEN_DOC=$(usex doc)
		-DBUILD_LIBSYSTEMD=no
		-DBUILD_TESTS=$(usex test)
	)

	PKG_CONFIG_PATH=${SDB}/src/libsystemd:${PKG_CONFIG_PATH} \
	cmake_src_configure
}

src_compile() {
	if ! use systemd; then
		BUILD_DIR=${SDB} \
		meson_src_compile version.h systemd:static_library
	fi

	cmake_src_compile all $(usev doc)
}

src_test() {
	if ! cmp -s {"${S}"/tests/integrationtests/files,/etc/dbus-1/system.d}/org.sdbuscpp.integrationtests.conf; then
		ewarn "Not running the tests as a D-Bus configuration file has not been"
		ewarn "installed yet or has changed since. The tests can be run after"
		ewarn "the package has been merged."
		return
	elif [[ ! -S /run/dbus/system_bus_socket ]]; then
		ewarn "Not running the tests as the system-wide D-Bus daemon is unavailable."
		return
	fi

	cmake_src_test
}

src_install() {
	cmake_src_install
	rm -v "${ED}"/usr/share/doc/${PF}/COPYING || die

	if use test; then
		# Delete installed test binaries.
		rm -rv "${ED}"/opt || die
	fi
}
