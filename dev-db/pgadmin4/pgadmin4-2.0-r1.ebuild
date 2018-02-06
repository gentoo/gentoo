# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 qmake-utils

DESCRIPTION="GUI administration and development platform for PostgreSQL"
HOMEPAGE="http://www.pgadmin.org/"
SRC_URI="mirror://postgresql/pgadmin/${PN}/v${PV}/source/${P}.tar.gz"

LICENSE="POSTGRESQL"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="doc"

RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
	dev-qt/qtwebengine:5[widgets]
"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

RDEPEND="${COMMON_DEPEND}
	>=app-text/htmlmin-0.1.10[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.3[${PYTHON_USEDEP}]
	>=dev-python/click-6.6[${PYTHON_USEDEP}]
	>=dev-python/extras-0.0.3[${PYTHON_USEDEP}]
	>=dev-python/fixtures-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.11.1[${PYTHON_USEDEP}]
	>=dev-python/flask-babel-0.11.1[${PYTHON_USEDEP}]
	>=dev-python/flask-gravatar-0.4.2[${PYTHON_USEDEP}]
	>=dev-python/flask-htmlmin-1.2[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/flask-mail-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/flask-migrate-2.0.3[${PYTHON_USEDEP}]
	>=dev-python/flask-paranoid-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/flask-principal-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/flask-security-1.7.5[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-2.1[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.12[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.9999999[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.24[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.3[${PYTHON_USEDEP}]
	>=dev-python/linecache2-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-0.23[${PYTHON_USEDEP}]
	>=dev-python/mimeparse-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6.2[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.9.1[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.11.13[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.1.19[${PYTHON_USEDEP}]
	>=dev-python/pytz-2014.10[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.6.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/speaklater-1.3[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.14[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/wtforms-2.0.2[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/${P}/runtime

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	default
}

src_configure() {
	eqmake5
}

src_compile() {
	default
	if use doc; then
		cd "${WORKDIR}"/${P} || die
		emake docs
	fi
}

src_install() {
	dobin pgAdmin4

	cd "${WORKDIR}"/${P} || die

	local APP_DIR=/usr/share/${PN}/web
	insinto "${APP_DIR}"
	doins -r web/*
	cat > "${D}${APP_DIR}"/config_local.py <<-EOF
		SERVER_MODE = False
		UPGRADE_CHECK_ENABLED = False
	EOF
	python_optimize "${D}${APP_DIR}"

	local CONFIG_DIR="/etc/xdg/pgadmin"
	dodir "${CONFIG_DIR}"
	cat > "${D}${CONFIG_DIR}"/pgadmin4.conf <<-EOF
		[General]
		ApplicationPath=${APP_DIR}
		PythonPath=$(python_get_sitedir)
	EOF

	if use doc; then
		rm -r docs/en_US/_build/html/_sources || die
		insinto /usr/share/${PN}/docs/en_US/_build
		doins -r docs/en_US/_build/html
	fi
}
