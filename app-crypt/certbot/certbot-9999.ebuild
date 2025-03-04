# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

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
	#KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	# Only for amd64, arm64 and x86 because of dev-python/python-augeas
	#KEYWORDS="~amd64 ~arm64 ~x86"
	# Only for amd64 and x86 because of dev-python/dns-lexicon
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Let’s Encrypt client to automate deployment of X.509 certificates"
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
	>=dev-python/josepy-1.13.0[${PYTHON_USEDEP}]
	<dev-python/josepy-2[${PYTHON_USEDEP}]
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

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	local S_BACKUP="${S}"

	local certbot_dirs=()
	local base module dir
	for base in "${CERTBOT_BASE[@]}"; do
		certbot_dirs+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" \
			&& certbot_dirs+=("certbot-${module}")
	done

	for dir in "${certbot_dirs[@]}"; do
		S="${WORKDIR}/${P}/${dir}"
		pushd "${S}" > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	done

	# Restore S
	S="${S_BACKUP}"
}

src_configure() {
	local S_BACKUP="${S}"

	local certbot_dirs=()
	local base module dir
	for base in "${CERTBOT_BASE[@]}"; do
		certbot_dirs+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" \
			&& certbot_dirs+=("certbot-${module}")
	done

	for dir in "${certbot_dirs[@]}"; do
		S="${WORKDIR}/${P}/${dir}"
		pushd "${S}" > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	done

	# Restore S
	S="${S_BACKUP}"
}

src_compile() {
	local S_BACKUP="${S}"

	local certbot_dirs=()
	local base module dir
	for base in "${CERTBOT_BASE[@]}"; do
		certbot_dirs+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" \
			&& certbot_dirs+=("certbot-${module}")
	done

	for dir in "${certbot_dirs[@]}"; do
		S="${WORKDIR}/${P}/${dir}"
		pushd "${S}" > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	done

	# Restore S
	S="${S_BACKUP}"
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

src_test() {
	local S_BACKUP="${S}"

	local certbot_dirs=()
	local base module dir
	for base in "${CERTBOT_BASE[@]}"; do
		certbot_dirs+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" \
			&& certbot_dirs+=("certbot-${module}")
	done

	for dir in "${certbot_dirs[@]}"; do
		S="${WORKDIR}/${P}/${dir}"
		pushd "${S}" > /dev/null || die
		distutils-r1_src_test
		popd > /dev/null || die
	done

	# Restore S
	S="${S_BACKUP}"
}

src_install() {
	local S_BACKUP="${S}"

	local certbot_dirs=()
	local base module dir
	for base in "${CERTBOT_BASE[@]}"; do
		certbot_dirs+=("${base}")
	done
	for module in "${CERTBOT_MODULES_EXTRA[@]}"; do
		use "certbot-${module}" \
			&& certbot_dirs+=("certbot-${module}")
	done

	for dir in "${certbot_dirs[@]}"; do
		S="${WORKDIR}/${P}/${dir}"
		pushd "${S}" > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	done

	# Restore S
	S="${S_BACKUP}"
}
