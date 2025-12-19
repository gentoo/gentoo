# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: Please bump in sync with dev-libs/libxslt

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
inherit python-r1 meson-multilib

DESCRIPTION="XML C parser and toolkit"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/libxml2"
	inherit git-r3
else
	inherit gnome.org
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}/${PN}-${PV%_rc*}"

LICENSE="MIT"
# see so_version = v_maj + v_min_compat for subslot
SLOT="2/16"
IUSE="doc icu python readline static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/libiconv
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		app-text/doxygen
		dev-libs/libxslt
	)
	python? ( app-text/doxygen )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xml2-config
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		default
	fi

	cd "${S}" || die
}

src_prepare() {
	default

	sed -e "/^dir_doc/ s/meson.project_name()$/\'${PF}\'/" -i meson.build || die
}

python_configure() {
	local emesonargs=(
		$(meson_feature icu)
		$(meson_native_use_feature readline)
		$(meson_native_use_feature readline history)
		-Ddocs=disabled
		-Dpython=enabled
		-Dschematron=enabled
	)
	mkdir "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_configure
	popd >/dev/null || die
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		$(meson_feature icu)
		$(meson_native_use_feature doc docs)
		$(meson_native_use_feature readline)
		$(meson_native_use_feature readline history)
		-Dpython=disabled
		-Dschematron=enabled

		# There has been a clean break with a soname bump.
		# It's time to deal with the breakage.
		# bug #935452
		-Dlegacy=disabled
	)
	meson_src_configure

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_configure
	fi
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_compile
	popd >/dev/null || die
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_compile
	fi
}

multilib_src_test() {
	meson_src_test

	if multilib_is_native_abi && use python ; then
		python_foreach_impl meson_src_test
	fi
}

python_install() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_install
	python_optimize
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_install
	fi

	meson_src_install
}

pkg_postinst() {
	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [[ -n "${ROOT}" ]]; then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# Need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${EROOT}/etc/xml/catalog"

		# We don't want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [[ ! -e "${CATALOG}" ]]; then
			[[ -d "${EROOT}/etc/xml" ]] || mkdir -p "${EROOT}/etc/xml"
			"${EPREFIX}"/usr/bin/xmlcatalog --create > "${CATALOG}"
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}
