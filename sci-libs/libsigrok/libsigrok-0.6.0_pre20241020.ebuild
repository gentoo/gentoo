# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
USE_RUBY="ruby31 ruby32"
RUBY_OPTIONAL="yes"
inherit python-r1 java-pkg-opt-2 ruby-ng udev xdg-utils

case ${PV} in
*9999*)
	EGIT_REPO_URI="https://github.com/sigrokproject/${PN}.git"
	inherit git-r3 autotools
	S="${WORKDIR}"/${P}
	;;
*_p*)
	inherit autotools unpacker
	COMMIT="f06f788118191d19fdbbb37046d3bd5cec91adb1"
	SRC_URI="https://sigrok.org/gitweb/?p=${PN}.git;a=snapshot;h=${COMMIT};sf=zip -> ${PN}-${COMMIT:0:7}.zip"
	S="${WORKDIR}"/${PN}-${COMMIT:0:7}
	;;
*)
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	S="${WORKDIR}"/${P}
	;;
esac

DESCRIPTION="Basic hardware drivers for logic analyzers and input/output file format support"
HOMEPAGE="https://sigrok.org/wiki/Libsigrok"

LICENSE="GPL-3"
if [[ ${PV} == *9999* ]]; then
	SLOT="0/9999"
else
	SLOT="0/4"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
IUSE="bluetooth +cxx ftdi gpib hidapi java nettle parport python ruby serial test +udev usb"
REQUIRED_USE="java? ( cxx )
	python? ( cxx ${PYTHON_REQUIRED_USE} )
	ruby? ( cxx || ( $(ruby_get_use_targets) ) )"

RESTRICT="!test? ( test )"

# We also support librevisa, but that isn't in the tree ...
COMMON_DEPEND="
	>=dev-libs/glib-2.32.0
	>=dev-libs/libzip-0.8:=
	sys-libs/zlib
	bluetooth? ( >=net-wireless/bluez-4.0:= )
	cxx? ( dev-cpp/glibmm:2 )
	ftdi? ( dev-embedded/libftdi:1 )
	gpib? ( sci-libs/linux-gpib )
	hidapi? ( >=dev-libs/hidapi-0.8.0 )
	nettle? ( dev-libs/nettle:= )
	parport? ( sys-libs/libieee1284 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	)
	ruby? ( $(ruby_implementations_depend) )
	serial? ( >=dev-libs/libserialport-0.1.1 )
	usb? ( virtual/libusb:1 )
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
DEPEND="${COMMON_DEPEND}
	java? (
		>=dev-lang/swig-3.0.6
		>=virtual/jdk-1.8:*
	)
	python? (
		>=dev-lang/swig-3.0.6
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
	ruby? ( >=dev-lang/swig-3.0.8 )
	test? ( >=dev-libs/check-0.9.4 )
"
BDEPEND="
	virtual/pkgconfig
	cxx? ( app-text/doxygen )
"
[[ ${PV} == *_p* ]] && BDEPEND+=" app-arch/unzip"

pkg_setup() {
	use python && python_setup
	use ruby && ruby-ng_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	case ${PV} in
	*9999*)
		git-r3_src_unpack ;;
	*_p*)
		unpack_zip ${A} ;;
	esac
	default
}

sigrok_src_prepare() {
	[[ ${PV} == *9999* || ${PV} == *_p* ]] && eautoreconf
}

each_ruby_prepare() {
	sigrok_src_prepare
}

src_prepare() {
	if use ruby; then
		# copy source to where ruby-ng_src_unpack puts it
		cp -rl "${S}" "${WORKDIR}"/all || die
		# ruby-ng_src_prepare calls default by itself
		ruby-ng_src_prepare
	fi
	default
	sigrok_src_prepare
	use python && python_copy_sources
}

sigrok_src_configure() {
	local myeconfargs=(
		--disable-python
		--disable-ruby
		$(use_with bluetooth libbluez)
		$(use_enable cxx)
		$(use_with ftdi libftdi)
		$(use_with hidapi libhidapi)
		$(use_enable java)
		$(use_with nettle libnettle)
		$(use_with parport libieee1284)
		$(use_with serial libserialport)
		$(use_with usb libusb)
	)
	econf "${myeconfargs[@]}" "${@}"
}

each_python_configure() {
	pushd "${BUILD_DIR}" > /dev/null || die
		sigrok_src_configure --enable-python
	popd >/dev/null || die
}

each_ruby_configure() {
	RUBY="${RUBY}" sigrok_src_configure --enable-ruby
}

src_configure() {
	sigrok_src_configure
	use python && python_foreach_impl each_python_configure
	use ruby && ruby-ng_src_configure
}

each_python_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die
		emake python-build
	popd >/dev/null || die
}

each_ruby_compile() {
	emake ruby-build
}

src_compile() {
	default
	use python && python_foreach_impl each_python_compile
	use ruby && ruby-ng_src_compile
}

src_test() {
	emake check
}

each_python_install() {
	pushd "${BUILD_DIR}" > /dev/null || die
		emake python-install DESTDIR="${D}"
		python_optimize
	popd >/dev/null || die
}

each_ruby_install() {
	emake ruby-install DESTDIR="${D}"
}

src_install() {
	default
	use python && python_foreach_impl each_python_install
	use ruby && ruby-ng_src_install
	use udev && udev_dorules contrib/*.rules
	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	udev_reload
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	udev_reload
}
