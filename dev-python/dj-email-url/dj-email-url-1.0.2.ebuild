# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Use an URL to configure email backend settings in your Django Application"
HOMEPAGE="https://github.com/migonzalvar/dj-email-url"
SRC_URI="https://github.com/migonzalvar/dj-email-url/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86"

DOCS=( CHANGELOG.rst README.rst )

python_test() {
	"${EPYTHON}" test_dj_email_url.py -v || die "Tests failed with ${EPYTHON}"
}
