require 'yaml'
require 'i18n'

def sanitize_name(name:, date: Time.now)
  I18n.config.available_locales = :en
  new_name = I18n.transliterate(name)
                 .gsub(/("|'|!|\?|:|\s\z)/, '')
                 .gsub(/(\s|\/|\\)/, '-')
                 .downcase
  date = date.strftime('%Y-%m-%d')
  "#{date}-#{new_name}"
end

def read_header(str)
  header = str.gsub(/\A---(.|\n)*?---/).first
  return {} unless header
  begin
    YAML.load(header)
  rescue Psych::SyntaxError
    {}
  end
end

desc 'Copy drafts to post and add missing header'
task :publish do
  Dir.chdir('_drafts') do
    Dir.glob('*.md') do |file|
      content = IO.read(file)

      header = read_header(content)
      header['title'] ||= File.basename(file, '.*')
      header['date'] ||= Time.now
      header['layout'] ||= 'post'

      content = content.gsub(/\A---(.|\n)*?---/, '')
      content = YAML.dump(header) << "---\n" << content

      new_name = sanitize_name(date: header['date'], name: header['title'])
      File.open("../_posts/#{new_name}.md", 'w+') { |f| f.write(content) }
    end
  end
end

desc "Rename post's file using YAML header"
task :rename do
  return unless Dir.exist?('_posts')

  Dir.chdir('_posts/') do
    Dir.glob('*.md') do |file|
      header = read_header(IO.read(file))

      title = header['title'] || File.basename(file, '.*')
      date = header['date'] || Time.now

      new_name = sanitize_name(date: date, name: title)
      File.rename(file, "#{new_name}.md")
    end
  end
end
