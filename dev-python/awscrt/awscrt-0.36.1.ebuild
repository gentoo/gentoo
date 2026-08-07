# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A common runtime for AWS Python projects"
HOMEPAGE="
	https://github.com/awslabs/aws-crt-python/
	https://pypi.org/project/awscrt/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/aws-c-common:=
	dev-libs/aws-c-auth:=
	dev-libs/aws-c-sdkutils:=
	dev-libs/aws-c-cal:=
	dev-libs/aws-c-io:=
	dev-libs/aws-c-compression:=
	dev-libs/aws-c-event-stream:=
	dev-libs/aws-c-http:=
	dev-libs/aws-c-auth:=
	dev-libs/aws-c-mqtt:=
	dev-libs/aws-c-s3:=
	dev-libs/aws-checksums:=
	dev-libs/openssl:=
	dev-libs/s2n-tls:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/h2[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# remove bundled libs
	rm -r crt || die
	export AWS_CRT_BUILD_USE_SYSTEM_LIBS=1

	# Internet/DNS
	sed -e 's:test_h2_remote_end_stream_ordering:_&:' \
		-e 's:test_cross_thread_http2_client:_&:' \
		-e 's:test_h2_client:_&:' \
		-e 's:test_h2_manual_write_exception:_&:' \
		-e 's:test_h2_remote_end_stream_ordering:_&:' \
		-i test/test_{aio,}http_client.py || die
}
