# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson cmake

DESCRIPTION="High-level C++ D-Bus library"
HOMEPAGE="https://github.com/Kistler-Group/sdbus-cpp"
SRC_URI="https://github.com/Kistler-Group/sdbus-cpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+ Nokia-Qt-LGPL-Exception-1.1" # Nothing to do with Qt but exception text is exactly the same.
SLOT="0/2"
KEYWORDS="~amd64"
IUSE="doc +elogind systemd test tools"
REQUIRED_USE="?? ( elogind systemd )"
RESTRICT="!test? ( test )"

RDEPEND="
	elogind? ( >=sys-auth/elogind-252 )
	systemd? ( >=sys-apps/systemd-252:= )
	!elogind? ( !systemd? ( >=sys-libs/basu-0.2.1 ) )
	tools? ( dev-libs/expat )
"

DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.14.0 )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

S="${WORKDIR}/sdbus-cpp-${PV}"

src_configure() {
	local mycmakeargs=(
		-DSDBUSCPP_BUILD_CODEGEN=$(usex tools)
		-DSDBUSCPP_BUILD_DOCS=yes
		-DSDBUSCPP_BUILD_DOXYGEN_DOCS=$(usex doc)
		-DSDBUSCPP_BUILD_LIBSYSTEMD=no
		-DSDBUSCPP_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
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
		rm -rv "${ED}"/usr/tests || die
	fi
}
