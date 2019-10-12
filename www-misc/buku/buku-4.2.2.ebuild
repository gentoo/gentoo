# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Powerful command-line bookmark manager"
HOMEPAGE="https://github.com/jarun/Buku"
SRC_URI="test? ( https://github.com/jarun/Buku/files/1319933/bookmarks.zip -> buku-bookmarks.zip )"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jarun/Buku"
else
	SRC_URI="${SRC_URI} mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test server"
RESTRICT="!test? ( test )"

CLIENT_DEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.13.1[${PYTHON_USEDEP}]"

SERVER_DEPEND="dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-admin[${PYTHON_USEDEP}]
	dev-python/flask-api[${PYTHON_USEDEP}]
	dev-python/flask-bootstrap[${PYTHON_USEDEP}]
	dev-python/flask-paginate[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]"

BDEPEND="app-arch/unzip"

RDEPEND="${CLIENT_DEPEND}
	server? ( ${SERVER_DEPEND} )"

DEPEND="${RDEPEND}
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use server; then
		eapply "${FILESDIR}/buku-4.1-disable-server.patch" || die
	fi

	if use test; then
		cd "tests/test_bukuDb" || die
		unpack "buku-bookmarks.zip" || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/zsh/site-functions
	doins auto-completion/zsh/_*

	newbashcomp auto-completion/bash/buku-completion.bash "${PN}"

	insinto /usr/share/zsh/site-functions
	newins auto-completion/zsh/_buku _buku

	doman buku.1
}

python_test() {
	local skipped=("_rec" "refreshdb" "tnyfy_url" "with_url" "test_browse"
					"search" "_tag" "_compactdb" "cleardb" "_database" )

	local args="not ${skipped[0]}"
	for i in "${skipped[@]:1}"; do
		args+=" and not ${i}"
	done

	pytest -vv -k "${args}" tests/test_*.py || die
}
