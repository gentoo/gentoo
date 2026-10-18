# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform AI Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="https://geekbench-cdn.b-cdn.net/GeekbenchAI-${PV}-Linux.tar.gz"
S="${WORKDIR}/GeekbenchAI-${PV}-Linux"

LICENSE="geekbench-ai"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist mirror"

RDEPEND="
	dev-cpp/tbb
	dev-libs/opencl-icd-loader
"
BDEPEND="dev-util/patchelf"

QA_PREBUILT="
	opt/geekbench-ai/banff
	opt/geekbench-ai/banff_avx2
	opt/geekbench-ai/banff_x86_64
	opt/geekbench-ai/libonnxruntime.so.1.18.1
	opt/geekbench-ai/libopenvino.so.2540
	opt/geekbench-ai/libopenvino_auto_batch_plugin.so
	opt/geekbench-ai/libopenvino_auto_plugin.so
	opt/geekbench-ai/libopenvino_c.so.2540
	opt/geekbench-ai/libopenvino_hetero_plugin.so
	opt/geekbench-ai/libopenvino_intel_cpu_plugin.so
	opt/geekbench-ai/libopenvino_intel_gpu_plugin.so
	opt/geekbench-ai/libopenvino_ir_frontend.so.2540
	opt/geekbench-ai/libopenvino_onnx_frontend.so.2540
	opt/geekbench-ai/libopenvino_paddle_frontend.so.2540
	opt/geekbench-ai/libopenvino_pytorch_frontend.so.2540
	opt/geekbench-ai/libopenvino_tensorflow_frontend.so.2540
	opt/geekbench-ai/libopenvino_tensorflow_lite_frontend.so.2540
"

src_prepare() {
	default

	# Fix QA insecure RUNPATHs
	patchelf --set-rpath /opt/geekbench-ai banff{,_avx2,_x86_64} || die
}

src_install() {
	exeinto /opt/geekbench-ai
	doexe banff{,_avx2,_x86_64}

	insinto /opt/geekbench-ai
	doins banff.plar banff-workload.plar

	# As not all needed deps are currently available in tree,
	# we need to install the provided libs.
	# Package 'media-libs/opencv' is missing OpenVINO support.
	# See: https://bugs.gentoo.org/762628
	# Package 'sci-libs/onnxruntime' is currently ::GURU only.
	insinto /opt/geekbench-ai
	doins libonnxruntime.so* libopenvino*.so*

	dodir /opt/bin
	dosym ../geekbench-ai/banff /opt/bin/geekbench-ai
}
