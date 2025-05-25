# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/certbot/certbot.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
else
	SRC_URI="
		https://github.com/certbot/certbot/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="Let's Encrypt client to automate deployment of X.509 certificates"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://pypi.org/project/certbot/
	https://letsencrypt.org/
"

LICENSE="Apache-2.0"
SLOT="0"

# acme required for certbot, and then required for modules
CERTBOT_BASE=(acme certbot)
# List of "subpackages" from tools/_release.sh (without acme which is already above)
CERTBOT_MODULES_EXTRA=(
	apache
	#dns-cloudflare # Requires missing packages, already in GURU
	#dns-digitalocean # Requires missing packages, already in GURU
	dns-dnsimple
	dns-dnsmadeeasy
	dns-gehirn
	dns-google
	dns-linode
	dns-luadns
	dns-nsone
	dns-ovh
	dns-rfc2136
	dns-route53
	dns-sakuracloud
	nginx
)

IUSE="selinux"
for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
	IUSE+=" certbot-${module}"
done

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

# See each setup.py for dependencies
# Also discard the previous related packages
# except their transition step
RDEPEND="
	!<app-crypt/acme-3.2.0-r100
	!<app-crypt/certbot-apache-3.2.0-r100
	!<app-crypt/certbot-dns-desec-3.2.0-r100
	!<app-crypt/certbot-dns-dnsimple-3.2.0-r100
	!<app-crypt/certbot-dns-nsone-3.2.0-r100
	!<app-crypt/certbot-dns-rfc2136-3.2.0-r100
	!<app-crypt/certbot-nginx-3.2.0-r100

	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/configargparse-1.5.3[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/cryptography-43.0.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/josepy-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-25.0.0[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	certbot-apache? (
		dev-python/python-augeas[${PYTHON_USEDEP}]
	)
	certbot-dns-dnsimple? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-dnsmadeeasy? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-gehirn? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-google? (
		>=dev-python/google-api-python-client-1.6.5[${PYTHON_USEDEP}]
		>=dev-python/google-auth-2.16.0[${PYTHON_USEDEP}]
	)
	certbot-dns-linode? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-luadns? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-nsone? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-dns-ovh? (
		>=dev-python/dns-lexicon-3.15.1[${PYTHON_USEDEP}]
	)
	certbot-dns-rfc2136? (
		>=dev-python/dnspython-2.6.1[${PYTHON_USEDEP}]
	)
	certbot-dns-route53? (
		>=dev-python/boto3-1.15.15[${PYTHON_USEDEP}]
	)
	certbot-dns-sakuracloud? (
		>=dev-python/dns-lexicon-3.14.1[${PYTHON_USEDEP}]
	)
	certbot-nginx? (
		>=dev-python/pyopenssl-25.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
	)
	selinux? ( sec-policy/selinux-certbot )
"
# RDEPEND+="
#	!<app-crypt/certbot-dns-cloudflare-3.2.0-r100
#
# 	>=dev-python/requests-toolbelt-0.3.0[${PYTHON_USEDEP}] # @TODO is still necessary?
# 	certbot-dns-cloudflare? (
# 		# Available in GURU
# 		>=dev-python/cloudflare-2.19[${PYTHON_USEDEP}]
# 		<dev-python/cloudflare-2.20[${PYTHON_USEDEP}]
# 	)
# 	certbot-dns-digitalocean? (
# 		# Available in GURU
# 		>=dev-python/digitalocean-1.11[${PYTHON_USEDEP}]
# 	)
# "

# Note: "docs" is not an actual directory under "S", they are actually
# under each modules, see python_compile_all redefinition, but keep
# this instruction enabled for dependency configuration.
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

CERTBOT_DIRS=()
# Stores temporary modules docs in each subdirectories,
# will be used for HTML_DOCS
CERTBOT_DOCS="${T}/docs"

src_prepare() {
	default

	# set CERTBOT_DIRS
	local base module
	for base in "${CERTBOT_BASE[@]}"; do
		CERTBOT_DIRS+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" &&
			CERTBOT_DIRS+=("certbot-${module}")
	done

	# Used to build documentation
	mkdir "${CERTBOT_DOCS}" || die

	# Remove "broken" symbolic link used as documentation.
	# Copy actual file, removing source breaks wheel building.
	rm -f "${S}/README.rst"
	cp "${S}/certbot/README.rst" "${S}/README.rst" || die
}

python_compile() {
	local dir
	for dir in "${CERTBOT_DIRS[@]}"; do
		pushd "${dir}" > /dev/null || die

		distutils-r1_python_compile

		popd > /dev/null || die
	done
}

# Used to build documentation
python_compile_all() {
	use doc || return

	local dir
	for dir in "${CERTBOT_DIRS[@]}"; do
		# There is no documentation in certbot-apache or certbot-nginx.
		if has "${dir}" "certbot-apache" "certbot-nginx"; then
			continue
		fi

		pushd "${dir}" > /dev/null || die

		sphinx_compile_all

		# Note: discard the `/.` in last entry suffix to avoid error
		# with `mv` command.
		mv "${HTML_DOCS[-1]%/.}" "${CERTBOT_DOCS}/${dir}" || die

		popd > /dev/null || die
	done

	# And finally give the result.
	# Note: the suffix `/.` here is to discard the holding directory.
	HTML_DOCS=( "${CERTBOT_DOCS}/." )
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	tc-has-64bit-time_t || EPYTEST_DESELECT+=(
		'certbot/_internal/tests/storage_test.py::RenewableCertTests::test_time_interval_judgments'
	)

	# Change for pytest rootdir is required.
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
