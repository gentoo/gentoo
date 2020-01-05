# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
EGIT_REPO_URI="https://github.com/openSUSE/spec-cleaner.git"
inherit distutils-r1
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="SUSE spec file cleaner and formatter"
HOMEPAGE="https://github.com/openSUSE/spec-cleaner"
[[ ${PV} != 9999 ]] && SRC_URI="https://github.com/openSUSE/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
[[ ${PV} != 9999 ]] &&
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${PYTHON_DEPS}
	>=app-arch/rpm-4.11.0.1
"

PATCHES=(
	# pytest-runner is only needed in test scenario
	"${FILESDIR}/${PN}-1.0.6-pytest-runner.patch"
)

[[ ${PV} != 9999 ]] && S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	# we have libexec
	sed -i \
		-e 's:lib/obs:libexec/obs:g' \
		setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test
}
