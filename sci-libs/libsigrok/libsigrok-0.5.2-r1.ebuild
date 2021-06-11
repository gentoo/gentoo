# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )
USE_RUBY="ruby26 ruby25"
RUBY_OPTIONAL="yes"

inherit python-r1 java-pkg-opt-2 ruby-ng udev xdg-utils

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Basic hardware drivers for logic analyzers and input/output file format support"
HOMEPAGE="https://sigrok.org/wiki/Libsigrok"

LICENSE="GPL-3"
SLOT="0/4"
IUSE="+cxx ftdi java parport python ruby serial static-libs test +udev usb"
REQUIRED_USE="java? ( cxx )
	python? ( cxx ${PYTHON_REQUIRED_USE} )
	ruby? ( cxx || ( $(ruby_get_use_targets) ) )"

RESTRICT="!test? ( test )"

# We also support librevisa, but that isn't in the tree ...
LIB_DEPEND="
	>=dev-libs/glib-2.32.0[static-libs(+)]
	>=dev-libs/libzip-0.8:=[static-libs(+)]
	cxx? ( dev-cpp/glibmm:2[static-libs(+)] )
	ftdi? ( dev-embedded/libftdi:1[static-libs(+)] )
	parport? ( sys-libs/libieee1284[static-libs(+)] )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	)
	ruby? ( $(ruby_implementations_depend) )
	serial? ( >=dev-libs/libserialport-0.1.1[static-libs(+)] )
	usb? ( virtual/libusb:1[static-libs(+)] )
"
RDEPEND="
	java? ( >=virtual/jre-1.4 )
	!static-libs? ( ${LIB_DEPEND//\[static-libs(+)]} )
	static-libs? ( ${LIB_DEPEND} )
"
DEPEND="${LIB_DEPEND//\[static-libs(+)]}
	cxx? ( app-doc/doxygen )
	java? (
		>=dev-lang/swig-3.0.6
		>=virtual/jdk-1.4
	)
	python? (
		>=dev-lang/swig-3.0.6
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
	ruby? ( >=dev-lang/swig-3.0.8 )
	test? ( >=dev-libs/check-0.9.4 )
	virtual/pkgconfig
"

S="${WORKDIR}"/${P}

PATCHES=(
	# https://sigrok.org/bugzilla/show_bug.cgi?id=1527
	"${FILESDIR}/${P}-swig-4.patch"
	# https://sigrok.org/bugzilla/show_bug.cgi?id=1526
	"${FILESDIR}/${P}-ruby-swig-docs.patch" # bug 705074
	"${FILESDIR}/${P}-check-0.15.patch"
)

pkg_setup() {
	use python && python_setup
	use ruby && ruby-ng_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	[[ ${PV} == *9999* ]] && git-r3_src_unpack || default
}

sigrok_src_prepare() {
	[[ ${PV} == *9999* ]] && eautoreconf
}

each_ruby_prepare() {
	sigrok_src_prepare
}

src_prepare() {
	if use ruby; then
		cp -rl "${S}" "${WORKDIR}"/all || die
		ruby-ng_src_prepare
	fi
	default
	sigrok_src_prepare
	use python && python_copy_sources
}

sigrok_src_configure() {
	econf \
		$(use_with ftdi libftdi) \
		$(use_with parport libieee1284) \
		$(use_with serial libserialport) \
		$(use_with usb libusb) \
		$(use_enable cxx) \
		$(use_enable java) \
		$(use_enable static-libs static) \
		"${@}"
}

each_ruby_configure() {
	RUBY="${RUBY}" sigrok_src_configure --enable-ruby --disable-python
}

each_python_configure() {
	cd "${BUILD_DIR}"
	sigrok_src_configure --disable-ruby --enable-python
}

src_configure() {
	sigrok_src_configure --disable-ruby --disable-python
	use ruby && ruby-ng_src_configure
	use python && python_foreach_impl each_python_configure
}

each_ruby_compile() {
	emake ruby-build
}

each_python_compile() {
	cd "${BUILD_DIR}"
	emake python-build
}

src_compile() {
	default
	use ruby && ruby-ng_src_compile
	use python && python_foreach_impl each_python_compile
}

src_test() {
	emake check
}

each_ruby_install() {
	emake ruby-install DESTDIR="${D}"
}

each_python_install() {
	cd "${BUILD_DIR}"
	emake python-install DESTDIR="${D}"
	python_optimize
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
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
