# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 desktop optfeature

DESCRIPTION="A booru-like media organizer for the desktop"
HOMEPAGE="http://hydrusnetwork.github.io/hydrus/ https://github.com/hydrusnetwork/hydrus"
SRC_URI="https://github.com/hydrusnetwork/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# hydrus itself is WTFPL
# icons included are CC-BY-2.5
LICENSE="WTFPL-2 CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+mpv +ffmpeg +lz4 socks +cloudscraper charts test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_MULTI_USEDEP}]
		dev-python/html5lib[${PYTHON_MULTI_USEDEP}]
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/psutil[${PYTHON_MULTI_USEDEP}]
		dev-python/pyopenssl[${PYTHON_MULTI_USEDEP}]
		dev-python/pyside2[widgets,gui,charts?,${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/send2trash[${PYTHON_MULTI_USEDEP}]
		dev-python/service_identity[${PYTHON_MULTI_USEDEP}]
		dev-python/six[${PYTHON_MULTI_USEDEP}]
		dev-python/twisted[${PYTHON_MULTI_USEDEP}]
		media-libs/opencv[python,${PYTHON_MULTI_USEDEP}]

		>=dev-python/QtPy-1.9.0-r4[pyside2,${PYTHON_MULTI_USEDEP}]
		dev-python/beautifulsoup:4[${PYTHON_MULTI_USEDEP}]

		cloudscraper? ( dev-python/cloudscraper[${PYTHON_MULTI_USEDEP}] )
		ffmpeg? ( media-video/ffmpeg )
		lz4? ( dev-python/lz4[${PYTHON_MULTI_USEDEP}] )
		mpv? (
			 media-video/mpv[libmpv,${PYTHON_MULTI_USEDEP}]
			 dev-python/python-mpv[${PYTHON_MULTI_USEDEP}]
		)
		socks? (
				|| ( dev-python/requests[socks5,${PYTHON_MULTI_USEDEP}]
					dev-python/PySocks[${PYTHON_MULTI_USEDEP}] )
		)
	')
"
BDEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		test? (
			dev-python/httmock[${PYTHON_MULTI_USEDEP}]
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/nose[${PYTHON_MULTI_USEDEP}]
			dev-python/unittest2[${PYTHON_MULTI_USEDEP}]
		)
	')
"

PATCHES=(
	"${FILESDIR}/userpath-in-local-share.patch"
)

# Delete files only needed for testing
delete_test_files() {
	rm test.py || die
	rm hydrus/hydrus_test.py || die
	rm -r hydrus/test/ || die
	rm -r static/testing/ || die
}

src_prepare() {
	default

	# If tests will run, leave the files until tests are run.
	# They will be deleted before installing the package.
	if ! use test; then
		delete_test_files
	fi

	# Contains pre-built binaries for other systems and a broken swf renderer for linux
	rm -r bin/ || die
	# Build files used for CI, not actually needed
	rm -r static/build_files || die
	# Duplicate license file, not needed
	rm license.txt || die
	# Python requirements files, not needed
	rm requirements_*.txt || die
}

src_compile() {
	python_optimize "${S}"
}

src_test() {
	# The tests use unittest, but are run with a custom runner script.
	# QT_QPA_PLATFORM is required to make them run without X
	export QT_QPA_PLATFORM=offscreen
	"${EPYTHON}" "${S}/test.py" || die "Tests failed"
}

src_install() {
	local DOC="${EPREFIX}/usr/share/doc/${PF}"
	elog "Hydrus includes an excellent manual, that can either be viewed at"
	elog "${DOC}/html/help/index.html"
	elog "or accessed through the hydrus help menu."

	mv "help my client will not boot.txt" "help_my_client_will_not_boot.txt" || die

	DOCS=(COPYING README.md Readme.txt help_my_client_will_not_boot.txt db/)
	HTML_DOCS=("${S}"/help/)
	einstalldocs

	if use test; then
		# Delete files only needed for tests now. No need to install them.
		# If the tests didn't run, the files have been deleted already.
		delete_test_files
	fi

	# These files are copied into DOC
	rm COPYING README.md Readme.txt help_my_client_will_not_boot.txt || die
	rm -r help/ db/ || die
	# The program expects to find documentation here, so add a symlink to DOC
	ln -s "${DOC}/html/help" help || die

	insopts -m0755
	insinto /opt/hydrus
	doins -r "${S}"/*

	exeinto /usr/bin

	sed "s/python/${EPYTHON}/" "${FILESDIR}/hydrus-server" > "${T}/hydrus-server" || die
	sed "s/python/${EPYTHON}/" "${FILESDIR}/hydrus-client" > "${T}/hydrus-client" || die

	python_doexe "${T}/hydrus-server"
	python_doexe "${T}/hydrus-client"

	make_desktop_entry "hydrus-client" "Hydrus Client" "/opt/hydrus/static/hydrus_non-transparent.png"\
					   "AudioVideo;FileTools;Graphics;Network;"
}

pkg_postinst() {
	optfeature "support for automatic port forwarding" "net-libs/miniupnpc"
}
