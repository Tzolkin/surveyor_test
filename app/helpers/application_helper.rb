module ApplicationHelper
  def flash_class(level)
    {
      notice: 'alert alert-info',
      success: 'alert alert-success',
      alert: 'alert alert-warning',
      error: 'alert alert-danger'
    }[level.to_sym]
  end
end
