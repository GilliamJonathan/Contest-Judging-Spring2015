class Attachment < ActiveRecord::Base
  def uploaded_file(contest, params)
    puts contest.inspect
    incoming_file = params[:attachment][:attachment]
    name =  'test.xls'
    directory = "public/"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(incoming_file.read) }
    
    workbook = Spreadsheet.open(path)
    worksheet = workbook.worksheet(0)
    1.upto worksheet.last_row_index do |index|
      row = worksheet.row(index)
      @project = contest.projects.build
      @project.name = row[0]
      @project.location = row[1]
      if !contest.categories.exists?("name"=> row[2])
        create_category(contest, row[2])
      end
      @project.category_id = contest.categories.find_by_name(row[2]).id
      @project.save
      puts @project.inspect
    end
  end
  
  def create_category(contest, category_name)
    @category = contest.categories.build
    @category.name = category_name
    @category.save
  end

  # def filename=(new_filename)
  #   write_attribute("filename", sanitize_filename(new_filename))
  # end

  # private
  # def sanitize_filename(filename)
  #   #get only the filename, not the whole path (from IE)
  #   just_filename = File.basename(filename)
  #   #replace all non-alphanumeric, underscore or periods with underscores
  #   just_filename.gsub(/[^\w\.\-]/, '_')
  # end
end
