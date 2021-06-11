# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite"
inherit desktop python-single-r1 qmake-utils xdg

DESCRIPTION="GUI administration and development platform for PostgreSQL"
HOMEPAGE="https://www.pgadmin.org/"
SRC_URI="https://ftp.postgresql.org/pub/pgadmin/${PN}/v${PV}/source/${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

# libsodium dep added because of 689678
COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/libsodium[-minimal]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwidgets:5
"
DEPEND="${COMMON_DEPEND}
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
		')
	)
	virtual/imagemagick-tools[png]
"

# In 4.25's requirement.txt, bcrypt is listed as <=3.17, but upstream's
# git history shows this is just for compatibility with <python-3.6.
# In 4.26's requirement.txt, cryptography is listed as <=3.0, but upstream's
# git history shows this is just for compatibility with Windows.
# 4.28; requirement.txt: Flask-Security was renamed to
# Flask-Security-Too. This is still the same dev-python/flask-security.
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/blinker-1.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-1.0.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-babelex-0.9.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-compress-1.4.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-gravatar-0.5.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-login-0.4.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-mail-0.9.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-migrate-2.4.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-paranoid-0.2.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-principal-0.4.0[${PYTHON_MULTI_USEDEP}]
		<dev-python/flask-security-4.0.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-sqlalchemy-2.4.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/flask-wtf-0.14.3[${PYTHON_MULTI_USEDEP}]
		>=dev-python/ldap3-2.5.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/passlib-1.7.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/psutil-5.7.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/psycopg-2.8[${PYTHON_MULTI_USEDEP}]
		>=dev-python/python-dateutil-2.8.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pytz-2020.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/simplejson-3.16.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/six-1.12.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/speaklater-1.3[${PYTHON_MULTI_USEDEP}]
		>=dev-python/sqlalchemy-1.3.13[${PYTHON_MULTI_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/sshtunnel-0.1.5[${PYTHON_MULTI_USEDEP}]
		>=dev-python/werkzeug-0.15.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/wtforms-2.2.1[${PYTHON_MULTI_USEDEP}]
		dev-python/bcrypt[${PYTHON_MULTI_USEDEP}]
		dev-python/cryptography[${PYTHON_MULTI_USEDEP}]
		dev-python/gssapi[${PYTHON_MULTI_USEDEP}]
		dev-python/python-email-validator[${PYTHON_MULTI_USEDEP}]
	')
"

S="${WORKDIR}"/${P}/runtime

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	default
}

src_configure() {
	export PGADMIN_PYTHON_DIR="${EPREFIX}/usr"
	eqmake5
}

src_compile() {
	default
	use doc && emake -C "${WORKDIR}"/${P} docs
}

src_install() {
	dobin pgAdmin4

	cd "${WORKDIR}"/${P} || die

	local APP_DIR=/usr/share/${PN}/web
	insinto "${APP_DIR}"
	doins -r web/.
	newins - config_local.py <<-EOF
		SERVER_MODE = False
		UPGRADE_CHECK_ENABLED = False
	EOF
	python_optimize "${D}${APP_DIR}"

	insinto /etc/xdg/pgadmin
	newins - pgadmin4.conf <<-EOF
		[General]
		ApplicationPath=${APP_DIR}
		PythonPath=$(python_get_sitedir)
	EOF

	if use doc; then
		rm -r docs/en_US/_build/html/_sources || die
		insinto /usr/share/${PN}/docs/en_US/_build
		doins -r docs/en_US/_build/html
	fi

	local s
	for s in 16 32 48 64 72 96 128 192 256; do
		convert runtime/pgAdmin4.png -resize ${s}x${s} ${PN}_${s}.png || die
		newicon -s ${s} ${PN}_${s}.png ${PN}.png
	done
	domenu "${FILESDIR}"/${PN}.desktop
}
