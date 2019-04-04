import os

# Accept all incoming requests
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.MultiKernelManager.default_kernel_name = 'python3'
c.NotebookApp.token = os.environ['JUPYTER_PASSWORD']
# c.NotebookApp.password = os.environ['JUPYTER_PASSWORD']
