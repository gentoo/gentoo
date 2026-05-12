# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 desktop optfeature

DESCRIPTION="A booru-like media organizer for the desktop"
HOMEPAGE="https://hydrusnetwork.github.io/hydrus/ https://github.com/hydrusnetwork/hydrus"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hydrusnetwork/hydrus.git"
else
	SRC_URI="
		https://github.com/hydrusnetwork/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/vaartis/hydrus/commit/cea10a10832dac21b247c3042d47c99fa2d52fa3.patch -> hydrus-637-test-fix.patch
"

	KEYWORDS="~amd64"
fi

# hydrus itself is WTFPL
# icons included are CC-BY-2.5
LICENSE="WTFPL-2 CC-BY-2.5"
SLOT="0"
IUSE="test doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

# RDEPEND is sorted as such:
# Python libraries with no specific requirements
# Python libraries with specific version, slot, or use requirements
# Non-python dependencies
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/cbor2[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/cloudscraper[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},lcms]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/python-mpv[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/send2trash[${PYTHON_USEDEP}]
		dev-python/service-identity[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]

		dev-python/qtpy[widgets,gui,svg,multimedia,${PYTHON_USEDEP}]

		media-libs/opencv[python,png,jpeg,${PYTHON_USEDEP}]
		media-video/ffmpeg
	')
"
BDEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		test? (
			dev-python/httmock[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
		)
		doc? ( dev-python/zensical )
	')
"

PATCHES=(
	"${FILESDIR}/userpath-in-local-share.patch"
)

src_prepare() {
	default

	# Contains pre-built binaries for other systems and a broken swf renderer for linux
	rm -r bin/ || die
	# Python requirements file, not needed
	rm requirements.txt || die
	# Remove unneeded additional scripts
	rm *.command *.sh *.bat || die
}

src_compile() {
	python_optimize "${S}"
	if use doc; then
		zensical build || die
		mv site html || die
	fi
}

src_test() {
	# The tests use unittest, but are run with a custom runner script.
	# QT_QPA_PLATFORM is required to make them run without X
	local -x QT_QPA_PLATFORM=offscreen
	"${EPYTHON}" "${S}/hydrus_test.py" || die "Tests failed"
}

src_install() {
	local doc="${EPREFIX}/usr/share/doc/${PF}"
	elog "Hydrus includes an excellent manual, that can either be viewed at"
	elog "${doc}/html/help/index.html"
	elog "or accessed through the hydrus help menu."

	mv "help my client will not boot.txt" "help_my_client_will_not_boot.txt" || die

	local DOCS=(COPYING README.md help_my_client_will_not_boot.txt db/)
	if use doc; then
	   DOCS+=(html/)
	fi
	einstalldocs

	# Files only needed for testing
	rm -r hydrus_test.py hydrus/hydrus_test_boot.py || die
	# Files only needed running from a git repo, or developer files
	rm -r git_pull.py open_venv.ps1 setup_help.py setup_venv.py .editorconfig .vscode || die
	rm -r hydrus/test/ static/testing/ || die
	# Build files used for CI and development, not actually needed. Has to be deleted after src_compile.
	# because it contains documentation
	rm -r static/build_files || die

	# ${DOCS[@]} files are copied into doc
	# ${S}/docs/ is the markdown source code for documentation
	# .gitignore/.github files aren't needed for the program to work, same with mkdocs files
	rm -r "${DOCS[@]}" "${S}/docs/" .gitignore .github/ mkdocs.yml mkdocs-gh-pages.yml || die
	if use doc; then
		# This is the cache directory from building documentation
		rm -r "${S}/.cache" || die
		# The program expects to find documentation here, so add a symlink to doc
		dosym "${doc}/html" /opt/hydrus/help
	fi

	insinto /opt/hydrus
	doins -r "${S}"/.

	exeinto /usr/bin
	python_newexe - hydrus-server < <(sed "s/python/${EPYTHON}/" "${FILESDIR}/hydrus-server" || die)
	python_newexe - hydrus-client < <(sed "s/python/${EPYTHON}/" "${FILESDIR}/hydrus-client" || die)

	make_desktop_entry "hydrus-client" "Hydrus Client" "/opt/hydrus/static/hydrus_non-transparent.png" \
					   "AudioVideo;FileTools;Graphics;Network;"
}

pkg_postinst() {
	optfeature "automatic port forwarding support" "net-libs/miniupnpc"
	optfeature "memory compression in the client" "dev-python/lz4"
	optfeature "SOCKS proxy support" "dev-python/requests[socks5]" "dev-python/pysocks"
	optfeature "bandwidth charts support" "dev-python/pyside[charts]"
	optfeature "PDF support" "dev-python/qtpy[pdfium]"
}
