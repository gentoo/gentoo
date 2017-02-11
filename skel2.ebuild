# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )

inherit autotools flag-o-matic python-single-r1 readme.gentoo-r1 toolchain-funcs

MY_PN=${PN/-/_}
MY_PV=${PV/_pre/-pre}

DESCRIPTION="The example ebuild"
HOMEPAGE="https://foo.example.org/"
SRC_URI="https://foo.example.org/${MY_PN}/${MY_PV}/source.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc openmp test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pyrequests[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:= )
		graphicsmagick? ( media-gfx/graphicsmagick:= )
	)
	openmp? ( dev-libs/boost:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )"

S=${WORKDIR}/${MY_PN}-${MY_PV}-src

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.3-build-system.patch
	"${FILESDIR}"/${PN}-1.2.3-desktop.patch
)
DOCS=( README DOCS Contributing.md )
HTML_DOCS=( doc/html/{index.html,style.css,logo.gif} )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# codebase uses C++11 features
	append-cxxflags -std=c++11

	econf \
		--disable-static \
		$(use_enable static static-libs) \
		$(use_enable openmp)
}

src_compile() {
	default
	if use doc; then
		emake -C fulldocs
		DOCS+=( fulldocs/_build/. )
	fi
}

src_install() {
	default

	local DOC_CONTENTS="The main application can be run
		with a GUI, although 'run-cli' is provided as
		command-line program"
	readme.gentoo_create_doc

	local f
	while IFS='' read -d $'\0' -r f; do
		dodoc "${f}"
	done < <(find . -iname '00ReadMe*' -print0)

	# the main 'run' binary causes a file collision
	mv "${ED%/}"/usr/bin/{run,my-run} || die
}

pkg_postinst() {
	if [[ ! -n ${REPLACING_VERSIONS} ]]; then
		einfo "Please read the manual in ${EROOT%/}/usr/share/doc/${PF}/README.gentoo"
		einfo "for further details on how to configure the application to run"
	fi
	readme.gentoo_print_elog
}
